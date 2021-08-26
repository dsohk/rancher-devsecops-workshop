#! /bin/bash -e

echo "Enter Rancher registration command for devsecops cluster: "
read RANCHER_REGCMD

# Clean up Rancher Registration Command
RANCHER_REGCMD=${RANCHER_REGCMD/--etcd/}
RANCHER_REGCMD=${RANCHER_REGCMD/--controlplane/}
RANCHER_REGCMD=${RANCHER_REGCMD/--worker/}
RANCHER_REGCMD=${RANCHER_REGCMD/--node-name */}

if [ -f ssh-mylab-devsecops-m1.sh ]; then
  echo
  echo "Register devsecops-m1 cluster ..."
  SSH_VM=$(<ssh-mylab-devsecops-m1.sh)
  eval "$SSH_VM $RANCHER_REGCMD --node-name devsecops-m1 --etcd --controlplane"
fi


# Count all worker nodes
for n in 1 2 3 4 
do
  if [ -f ssh-mylab-devsecops-w$n.sh ]; then
    echo
    echo "Register devsecops-w$n cluster ..."
    sleep $((RANDOM % 10))
    SSH_VM=$(<ssh-mylab-devsecops-w$n.sh)
    eval "$SSH_VM $RANCHER_REGCMD --node-name devsecops-w$n --worker"
  fi
done 


