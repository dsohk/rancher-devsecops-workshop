#! /bin/bash -e

# Check if devsecops.cfg file exists
if [ ! -f $HOME/.kube/devsecops.cfg ]; then
  echo "Please copy the kubeconfig file of Rancher devsecops cluster into $HOME/kube/devsecops.cfg file before running this script."
  exit
fi
export KUBECONFIG=$HOME/.kube/devsecops.cfg

helm repo add longhorn https://charts.longhorn.io
helm repo update

helm install longhorn longhorn/longhorn \
  --set persistence.defaultClassReplicaCount=1 \
  --set persistence.reclaimPolicy=Delete \
  --version=1.4.0 \
  --namespace longhorn-system \
  --create-namespace

echo "Your Longhorn is provisioning...."
while [ `kubectl -n longhorn-system get deploy | grep longhorn- | grep 1/1 | wc -l` -ne 2 ]
do
  sleep 10
  echo "Wait while longhorn is still provisioning..."
  kubectl get deploy -n longhorn-system
done

echo "Your Longhorn CSI is provisioning...."
while [ `kubectl -n longhorn-system get deploy | grep csi- | grep 3/3 | wc -l` -ne 4 ]
do
  sleep 10
  echo "Wait while longhorn CSI is still provisioning..."
  kubectl get deploy -n longhorn-system
done

echo
echo "Your longhorn is ready..."
echo
