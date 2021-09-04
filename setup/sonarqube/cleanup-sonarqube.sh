#! /bin/bash

# Check if devsecops.cfg file exists
if [ ! -f $HOME/.kube/devsecops.cfg ]; then
  echo "Please copy the kubeconfig file of Rancher devsecops cluster into $HOME/kube/devsecops.cfg file before running this script."
  exit
fi
export KUBECONFIG=$HOME/.kube/devsecops.cfg


helm uninstall sonarqube -n sonarqube
kubectl delete ns sonarqube
rm -rf helm-chart-sonarqube
