#! /bin/bash -e

if [ ! -f ssh-mylab-devsecops-m1.sh ]; then
  echo "Please start your lab before executing this script."
  exit
fi

echo "Enter Rancher registration command for devsecops cluster: "
read RANCHER_REGCMD

# Clean up Rancher Registration Command
RANCHER_REGCMD=${RANCHER_REGCMD/--etcd/}
RANCHER_REGCMD=${RANCHER_REGCMD/--controlplane/}
RANCHER_REGCMD=${RANCHER_REGCMD/--worker/}
RANCHER_REGCMD=${RANCHER_REGCMD/--node-name */}
RANCHER_REGCMD=${RANCHER_REGCMD/--address */}
RANCHER_REGCMD=${RANCHER_REGCMD/--internal-address */}

# Obtain the IP addresses of cluster1
source ./mylab_vm_prefix.sh
if [ -f ssh-mylab-devsecops-m1.sh ]; then
  VM=$VM_PREFIX-devsecops-m1
  PUB_IP=`cat mylab_vm_list.txt | grep $VM | cut -d '|' -f 4 | xargs`
  PRIV_IP=`cat mylab_vm_list.txt | grep $VM | cut -d '|' -f 3 | xargs`
  echo
  echo "Register devsecops-m1 cluster ..."
  SSH_VM=$(<ssh-mylab-devsecops-m1.sh)
  CMD="$RANCHER_REGCMD --node-name devsecops-m1 --address $PUB_IP --internal-address $PRIV_IP --etcd --controlplane"
  echo $CMD
  eval "$SSH_VM \"$CMD\""
  sleep 10
fi


# Count all worker nodes
for n in 1 2
do
  if [ -f ssh-mylab-devsecops-w$n.sh ]; then
    VM=$VM_PREFIX-devsecops-w$n
    PUB_IP=`cat mylab_vm_list.txt | grep $VM | cut -d '|' -f 4 | xargs`
    PRIV_IP=`cat mylab_vm_list.txt | grep $VM | cut -d '|' -f 3 | xargs`
    echo
    echo "Register devsecops-w$n cluster ..."
    sleep 5
    SSH_VM=$(<ssh-mylab-devsecops-w$n.sh)
    CMD="$RANCHER_REGCMD --node-name devsecops-w$n --address $PUB_IP --internal-address $PRIV_IP --worker"
    echo $CMD
    eval "$SSH_VM \"$CMD\""
  fi
done 


echo
echo "The devsecops cluster is now being provisioned by Rancher. It may take a few minutes to complete."
echo "Once it's ready, please install Longhorn on it and download KUBECONFIG file into your Harbor VM. Thank you!"
echo

