#! /bin/bash -e

for vm in rancher devsecops-m1 devsecops-w1 devsecops-w2 devsecops-w3 devsecops-w4 cluster1 cluster2; do
  echo
  echo "Distribute the self-signed harbor certs to $vm ..."
  scp $HOME/myharbor.sh $vm:~
  scp $HOME/04-configure-containerd-registry.sh $vm:~/configure-containerd-node.sh
  ssh $vm "sudo ./configure-containerd-node.sh"
done

