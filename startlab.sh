#! /bin/bash -e

cat setup/_banner.txt
source setup/_awsls_functions.sh
echo
echo "Welcome to SUSE Rancher DevSecOps Hands-on Lab on AWS Lightsail ..."
echo "This script will help you to provision VMs on AWS Lightsail to get started to run your lab exercise. By default, this script will install Rancher for you after VM is up."
echo

function check_sysreq() {
  echo Checking pre-requisites...
  if ! [ -x "$(command -v git)" ]; then
    echo 'Error: git is not installed. Please install git before running this script.' >&2
    exit 1
  else
    echo 'git installed'
  fi
  if ! [ -x "$(command -v aws)" ]; then
    echo 'Error: aws is not installed. Please install awscli before running this script.' >&2
    exit 1
  elif echo "$(aws --version)" | grep -q "aws-cli/2"; then
    echo "awscli v2 installed"
  else
    echo 'Error: aws cli has to be at least version 2. Please reinstall with the latest awscli before running this script.' >&2
    exit 1
  fi
  echo
}

function usage() {
  echo "usage: ./startlab.sh [options]"
  echo "-s    | --skip-rancher              Skip deploying Rancher after VM is up."
  echo "-h    | --help                      Brings up this menu"
  echo
}

# show help usage
if [ "$1" == "" ]; then usage; fi

cmdopt_auto_deploy_rancher=true
while [ "$1" != "" ]; do
    case $1 in
        -s | --skip-rancher )
            shift
            cmdopt_auto_deploy_rancher=false
            echo "NOTE: You chose to deploy Rancher on your own after your VM on AWS is up."
            echo
            break
        ;;
        -h | --help )    usage
            exit
        ;;
    esac
    shift
done

# check pre-requisites
check_sysreq;

export VM_PREFIX=suse0908
echo "export VM_PREFIX=$VM_PREFIX" > mylab_vm_prefix.sh

export RANCHER_VERSION=v2.6.9
echo "export RANCHER_VERSION=$RANCHER_VERSION" > mylab_rancher_version.sh

title="Select Your Preferred AWS Environment to run your lab:"
options=(US/Canada Europe Asia/Pacific)
echo "$title"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do
  case "$REPLY" in
  1) echo "$opt "; export AWS_CONTINENT=US; break;;
  2) echo "$opt "; export AWS_CONTINENT=EU; break;;
  3) echo "$opt "; export AWS_CONTINENT=AP; break;;
  $((${#options[@]}+1))) echo "Aborted. Bye!!"; exit;;
  *) echo "Invalid choice. Please try another one.";continue;;
  esac
done

# Retrieve AWS regions metadata based on chosen continent
unset options
IFS='
'
options=($(cat setup/_awsls_locations.txt | grep $AWS_CONTINENT | cut -d '|' -f 2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'))
unset IFS

echo "Select regions"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do
  if (( 1 <= $REPLY && $REPLY <= ${#options[@]} ))
  then
    export AWSLS_CHOSEN_REGION="${options[$REPLY - 1]}"
    echo "You picked:" $AWSLS_CHOSEN_REGION
    export AWS_REGION=`cat setup/_awsls_locations.txt | grep "$AWSLS_CHOSEN_REGION" | cut -d '|' -f 3 | xargs`
    export AWS_AVAIL_AZ=`cat setup/_awsls_locations.txt | grep "$AWSLS_CHOSEN_REGION" | cut -d '|' -f 4 | xargs`
    export AWSLS_VM_SIZE_SUFFIX=`cat setup/_awsls_locations.txt | grep "$AWSLS_CHOSEN_REGION" | cut -d '|' -f 5 | xargs`
    break
  elif (( $REPLY == $((${#options[@]} + 1)) ))
  then
    echo "Aborted. Bye!!"
    exit
  else
    echo "Invalid choice. Please try again."; continue;
  fi
done

echo "export AWS_REGION=${AWS_REGION}" > mylab_aws_region.sh

# Instance Sizes
# medium = 2 vCPU + 4GB RAM
# large = 2 vCPU + 8GB RAM
# xlarge = 4 vCPU + 16GB RAM
# aws lightsail get-bundles
export AWS_SIZE_MEDIUM="medium_${AWSLS_VM_SIZE_SUFFIX}"
export AWS_SIZE_LARGE="large_${AWSLS_VM_SIZE_SUFFIX}"
export AWS_SIZE_XLARGE="xlarge_${AWSLS_VM_SIZE_SUFFIX}"

echo "Provisioning VM in your AWS Lightsail region $AWS_REGION as lab environment ..."
create-vm $VM_PREFIX-rancher $AWS_SIZE_XLARGE
create-vm $VM_PREFIX-harbor  $AWS_SIZE_MEDIUM "systemctl enable docker; systemctl start docker; zypper in -y git-core; docker pull susesamples/myjenkins:v1.0;"
create-vm $VM_PREFIX-devsecops-m1 $AWS_SIZE_MEDIUM
create-vm $VM_PREFIX-devsecops-w1 $AWS_SIZE_XLARGE "zypper in -y nfs-client;"
create-vm $VM_PREFIX-devsecops-w2 $AWS_SIZE_XLARGE "zypper in -y nfs-client;"
create-vm $VM_PREFIX-cluster1 $AWS_SIZE_MEDIUM
create-vm $VM_PREFIX-cluster2 $AWS_SIZE_MEDIUM

# wait until all VMs are running
while list-vm | grep -q 'pending'
do
  echo "Wait until all VMs are up and running..."
  list-vm
  sleep 10
done
echo "All VMs are up and running now..."
list-vm

echo "Configure firewall rules for the VMs on the lab"
open-vm-standard-network-port $VM_PREFIX-rancher
open-vm-specific-network-port $VM_PREFIX-rancher 80 80
open-vm-specific-network-port $VM_PREFIX-rancher 443 443
open-vm-standard-network-port $VM_PREFIX-harbor
open-vm-specific-network-port $VM_PREFIX-harbor 30443 30443
open-vm-standard-network-port $VM_PREFIX-devsecops-m1
open-vm-specific-network-port $VM_PREFIX-devsecops-m1 6443 6443
open-vm-standard-network-port $VM_PREFIX-devsecops-w1
open-vm-specific-network-port $VM_PREFIX-devsecops-w1 30000 32767
open-vm-standard-network-port $VM_PREFIX-devsecops-w2
open-vm-specific-network-port $VM_PREFIX-devsecops-w2 30000 32767
open-vm-standard-network-port $VM_PREFIX-cluster1
open-vm-specific-network-port $VM_PREFIX-cluster1 30000 32767
open-vm-standard-network-port $VM_PREFIX-cluster2
open-vm-specific-network-port $VM_PREFIX-cluster2 30000 32767


echo "Capture all the VM IP addresses into a file"
cat mylab_aws_region.sh > mylab_vm_list.txt
list-vm >> mylab_vm_list.txt

echo "Download default AWS lightsail SSH key pair from your region $AWS_REGION"
download-key-pair

# write ssh file for easy access
echo "Generating shortcut ssh files for VM access..."
for vm in rancher harbor devsecops-m1 devsecops-w1 devsecops-w2 cluster1 cluster2; do
  VM_IP=`cat mylab_vm_list.txt | grep $VM_PREFIX-$vm | cut -d '|' -f 4 | xargs`
  echo "ssh -o StrictHostKeyChecking=no -i mylab.key ec2-user@$VM_IP" > ssh-mylab-$vm.sh
  chmod +x ssh-mylab-$vm.sh
done

# build mylab-ssh-config file
touch mylab-ssh-config
echo "Host *" > mylab-ssh-config
echo "  StrictHostKeyChecking no" >> mylab-ssh-config
echo >> mylab-ssh-config
for vm in rancher harbor devsecops-m1 devsecops-w1 devsecops-w2 cluster1 cluster2; do
  VM_IP=`cat mylab_vm_list.txt | grep $VM_PREFIX-$vm | cut -d '|' -f 4 | xargs`
  echo "Host $vm" >> mylab-ssh-config
  echo "  HostName $VM_IP" >> mylab-ssh-config
  echo "  User ec2-user" >> mylab-ssh-config
  echo "  IdentityFile ~/.ssh/mylab.key" >> mylab-ssh-config
  echo >> mylab-ssh-config
done
chmod 600 mylab-ssh-config

export SSH_OPTS="-o StrictHostKeyChecking=no"
for vm in rancher harbor; do
  VM_IP=`get-vm-public-ip $VM_PREFIX-$vm`
  echo "SSH into $VM_PREFIX-$vm (IP:$VM_IP) and upload files into this server ..."
  until ssh $SSH_OPTS -i mylab.key ec2-user@$VM_IP true; do
      sleep 5
  done
  scp $SSH_OPTS -i mylab.key mylab.key ec2-user@$VM_IP:~/.ssh/
  scp $SSH_OPTS -i mylab.key mylab-ssh-config ec2-user@$VM_IP:~/.ssh/config
  scp $SSH_OPTS -i mylab.key setup/$vm/*.*  ec2-user@$VM_IP:~/
done

# upload files to be deployed onto devsecops cluster
echo "Upload files to be executed onto devsecops cluster into harbor instance ..."
HARBOR_IP=`get-vm-public-ip $VM_PREFIX-harbor`
ssh $SSH_OPTS -i mylab.key ec2-user@$HARBOR_IP mkdir -p devsecops/{jenkins,sonarqube,anchore,longhorn}
scp $SSH_OPTS -i mylab.key mylab_vm_list.txt ec2-user@$HARBOR_IP:~
scp $SSH_OPTS -i mylab.key mylab_vm_prefix.sh ec2-user@$HARBOR_IP:~
scp $SSH_OPTS -i mylab.key setup/jenkins/*.* ec2-user@$HARBOR_IP:~/devsecops/jenkins
scp $SSH_OPTS -i mylab.key setup/sonarqube/*.* ec2-user@$HARBOR_IP:~/devsecops/sonarqube
scp $SSH_OPTS -i mylab.key setup/anchore/*.* ec2-user@$HARBOR_IP:~/devsecops/anchore
scp $SSH_OPTS -i mylab.key setup/longhorn/*.* ec2-user@$HARBOR_IP:~/devsecops/longhorn


# install rancher now?
function install_rancher() {
  RANCHER_IP=`cat mylab_vm_list.txt | grep $VM_PREFIX-rancher | cut -d '|' -f 4 | xargs`
  scp -o StrictHostKeyChecking=no -i mylab.key mylab_rancher_version.sh ec2-user@$RANCHER_IP:~
  ssh -o StrictHostKeyChecking=no -i mylab.key ec2-user@$RANCHER_IP sh 99-one-step-install-rancher.sh
}
if [[ 'true' == $cmdopt_auto_deploy_rancher ]]
then
  install_rancher
fi

echo "Your lab environment on AWS Lightsail $AWS_REGION is ready. "
echo
echo "Here's the list of VMs running in your lab environment (See file: mylab_vm_list.txt):"
list-vm
echo "To SSH into the VM on the lab, you can run this command:"
echo
echo "./ssh-mylab-<vm>.sh"
echo
