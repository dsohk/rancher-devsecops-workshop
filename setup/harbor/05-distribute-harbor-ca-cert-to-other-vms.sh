#! /bin/bash -e

for vm in rancher devsecops-m1 devsecops-w1 devsecops-w2 devsecops-w3 cluster1 cluster2; do
  echo
  echo "Distribute the self-signed harbor certs to $vm ..."
  scp myharbor.sh $vm:~
  scp 04-configure-docker-client.sh $vm:~/configure-docker-client.sh
  ssh $vm ./configure-docker-client.sh
done

echo
echo
echo ============================================================
echo "Congrats! Your Harbor instance has been setup successfully."
cat harbor-credential.txt
echo

