#! /bin/bash -e

cat _banner.txt
source _awsls_functions.sh
echo
echo "Welcome to SUSE Rancher DevSecOps Hands-on Lab on AWS Lightsail ..."
echo "This script will help you to provision VMs on AWS Lightsail to get started to run your lab exercise."
echo
echo ""

# Supported AWS Lighsail Regions: 
# https://lightsail.aws.amazon.com/ls/docs/en_us/articles/understanding-regions-and-availability-zones-in-amazon-lightsail
title="Select Your Preferred AWS Environment to run your lab:"
options=("Tokyo" "Seoul" "Singapore" "Sydney" "Mumbai")
echo "$title"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do 
  case "$REPLY" in
  1) echo "You picked $opt "; export AWS_REGION=ap-northeast-1; export AWSLS_VM_SIZE_SUFFIX=_2_0; break;;
  2) echo "You picked $opt "; export AWS_REGION=ap-northeast-2; export AWSLS_VM_SIZE_SUFFIX=_2_0; break;;
  3) echo "You picked $opt "; export AWS_REGION=ap-southeast-1; export AWSLS_VM_SIZE_SUFFIX=_2_0; break;;
  4) echo "You picked $opt "; export AWS_REGION=ap-southeast-2; export AWSLS_VM_SIZE_SUFFIX=_2_2; break;;
  5) echo "You picked $opt "; export AWS_REGION=ap-south-1;     export AWSLS_VM_SIZE_SUFFIX=_2_1; break;;
  $((${#options[@]}+1))) echo "Aborted. Bye!!"; break;;
  *) echo "Invalid choice. Please try another one.";continue;;
  esac
done

echo "export AWS_REGION=${AWS_REGION}" > mylab_aws_region.sh
export AWS_AZ=${AWS_REGION}a
# Instance Sizes
# medium = 4GB RAM; large = 8GB RAM
# aws lightsail get-bundles
export AWS_SIZE_MEDIUM="medium${AWSLS_VM_SIZE_SUFFIX}"
export AWS_SIZE_LARGE="large${AWSLS_VM_SIZE_SUFFIX}"

echo "Starting VM in your AWS Lighsail region $AWS_REGION ..."
create-vm demo-rancher $AWS_SIZE_MEDIUM
create-vm demo-harbor  $AWS_SIZE_MEDIUM
create-vm demo-devsecops-m1 $AWS_SIZE_MEDIUM
create-vm demo-devsecops-w1 $AWS_SIZE_LARGE
create-vm demo-devsecops-w2 $AWS_SIZE_LARGE
create-vm demo-devsecops-w3 $AWS_SIZE_LARGE
create-vm demo-cluster1 $AWS_SIZE_MEDIUM
create-vm demo-cluster2 $AWS_SIZE_MEDIUM

# wait until all VMs are running
while list-vm | grep -q 'pending'
do
  echo "Wait until all VMs are up and running..."
  list-vm
  sleep 10
done

echo "Configure firewall rules for the VMs on the lab"
configure-vm-network-port demo-rancher
configure-vm-network-port demo-harbor
configure-vm-network-port demo-devsecops-m1
configure-vm-network-port demo-devsecops-w1
configure-vm-network-port demo-devsecops-w2
configure-vm-network-port demo-devsecops-w3
configure-vm-network-port demo-cluster1
configure-vm-network-port demo-cluster2

echo "Capture all the VM IP addresses into a file"
cat mylab_aws_region.sh > mylab_vm_list.txt
list-vm >> mylab_vm_list.txt

echo "Download default AWS lightsail SSH key pair from your region $AWS_REGION"
download-key-pair

export SSH_OPTS="-o ConnectTimeout=120 -o StrictHostKeyChecking=no"
export RANCHER_IP=`get-vm-public-ip demo-rancher`
echo "SSH into Rancher Server $RANCHER_IP and upload files into this server ..."
scp $SSH_OPTS -i mylab.key mylab_vm_list.txt ec2-user@$RANCHER_IP:~/
scp $SSH_OPTS -i mylab.key mylab.key ec2-user@$RANCHER_IP:~/

echo 
echo
echo "Your lab environment on AWS Lightsail $AWS_REGION is ready. "
echo
echo "Here's the list of VMs running in your lab environment (See file: mylab_vm_list.txt):"
list-vm
echo
echo "To SSH into the VM on the lab, you can run this command:"
echo
echo "ssh -i mylab.key ec2-user@<YOUR-VM-PUBLIC-IP>"
echo
echo "Please continue the lab exercises according to our guide. Thank you! Have a nice day!"

