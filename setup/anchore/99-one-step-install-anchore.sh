#! /bin/bash

helm repo add anchore https://charts.anchore.io
helm repo update

helm install anchore anchore/anchore-engine \
  --create-namespace \
  -n anchore

echo "Your Anchore instance is provisioning...."
while [ `kubectl get deploy -n anchore | grep 1/1 | wc -l` -ne 6 ]
do
  sleep 10
  echo "Wait while anchore is still provisioning..."
  kubectl get deploy -n anchore
done

echo "Your Anchore is now successfully provisioned."
echo
