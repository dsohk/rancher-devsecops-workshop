#! /bin/bash -e

if [ ! -f ssh-mylab-cluster1.sh ]; then
  echo "Please start your lab before executing this script."
  exit
fi

echo "Enter Rancher registration command for cluster1: "
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
VM=$VM_PREFIX-cluster1
PUB_IP=`cat mylab_vm_list.txt | grep $VM | cut -d '|' -f 4 | xargs`
PRIV_IP=`cat mylab_vm_list.txt | grep $VM | cut -d '|' -f 3 | xargs`

echo
echo "Registering cluster1 as All-in-one RKE..."
SSH_VM=$(<ssh-mylab-cluster1.sh)
CMD="$RANCHER_REGCMD --node-name cluster1 --address $PUB_IP --internal-address $PRIV_IP --etcd --controlplane --worker"
echo $CMD
eval "$SSH_VM \"$CMD\""

