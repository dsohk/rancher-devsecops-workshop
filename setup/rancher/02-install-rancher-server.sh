#! /bin/bash -e

# install rancher server
echo "Install Rancher Server using helm chart on RKE2 ..."

source $HOME/mylab_rancher_version.sh

echo "Install RKE2 v1.21 ..."
sudo bash -c 'curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL="v1.21" sh -'
sudo mkdir -p /etc/rancher/rke2
sudo bash -c 'echo "write-kubeconfig-mode: \"0644\"" > /etc/rancher/rke2/config.yaml'
sudo systemctl enable rke2-server.service
echo "Starting rke2-server service ..."
sudo systemctl start rke2-server.service

mkdir -p $HOME/.kube
ln -s /etc/rancher/rke2/rke2.yaml $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config

# Wait until the RKE2 is ready
echo "Initializing RKE2 cluster ..."
while [ `kubectl get deploy -n kube-system | grep 1/1 | wc -l` -ne 3 ]
do
  sleep 5
  kubectl get po -n kube-system
done
echo "Your RKE2 cluster is ready!"
kubectl get node

echo "Install Cert Manager v1.5.1 ..."
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.5.1 \
  --create-namespace
kubectl -n cert-manager rollout status deploy/cert-manager

# Wait until cert-manager deployment complete
echo "Wait until cert-manager deployment finish ..."
while [ `kubectl get deploy -n cert-manager | grep 1/1 | wc -l` -ne 3 ]
do
  sleep 5
  kubectl get po -n cert-manager
done

# Install Rancher with helm chart
echo "Install Rancher ${RANCHER_VERSION} ..."
RANCHER_IP=`curl -qs http://checkip.amazonaws.com`
RANCHER_FQDN=rancher.$RANCHER_IP.sslip.io
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

# helm install rancher rancher-latest/rancher \
#   --namespace cattle-system \
#   --set hostname=$RANCHER_FQDN \
#   --set replicas=3 \
#   --set auditLog.level=1 \
#   --set auditLog.destination=hostPath \
#   --set auditLog.hostPath=/var/log/rancher/audit \
#   --version ${RANCHER_VERSION} --devel \
#   --create-namespace

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=$RANCHER_FQDN \
  --set replicas=1 \
  --version ${RANCHER_VERSION} --devel \
  --create-namespace

echo "Wait until cattle-system deployment finish ..."
while [ `kubectl get deploy -n cattle-system | grep 1/1 | wc -l` -ne 1 ]
do
  sleep 5
  kubectl get po -n cattle-system
done

RANCHER_BOOTSTRAP_PWD=`kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{ "\n" }}'`


echo
echo "---------------------------------------------------------"
echo "Your Rancher Server is ready."
echo
echo "Your Rancher Server URL: https://${RANCHER_FQDN}" > rancher-url.txt
echo "Bootstrap Password: ${RANCHER_BOOTSTRAP_PWD}" >> rancher-url.txt
cat rancher-url.txt
echo "---------------------------------------------------------"
