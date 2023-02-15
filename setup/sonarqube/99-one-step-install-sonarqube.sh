#! /bin/bash

# Check if devsecops.cfg file exists
if [ ! -f $HOME/.kube/devsecops.cfg ]; then
  echo "Please copy the kubeconfig file of Rancher devsecops cluster into $HOME/kube/devsecops.cfg file before running this script."
  exit
fi
export KUBECONFIG=$HOME/.kube/devsecops.cfg


# check if the longhorn has been installed
if [ `kubectl get sc | grep default | wc -l` -ne 1 ]; then
  echo "Please deploy longhorn on devsecops cluster before running this script."
  exit
fi

# check if git is installed
git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE -ne 0 ]; then
  sudo zypper install -y git-core
fi

set -e

#git clone https://github.com/SonarSource/helm-chart-sonarqube.git --depth 1 -b sonarqube-lts-1.0.29
#cd helm-chart-sonarqube/charts/sonarqube
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
kubectl create namespace sonarqube
helm upgrade --install -f ~/sonarqube-values.yaml -n sonarqube sonarqube-lts sonarqube/sonarqube-lts

#helm dependency update
#kubectl create namespace sonarqube

#kubectl taint nodes devsecops-w1 sonarqube=true:NoSchedule --overwrite=true
#kubectl label node devsecops-w1  sonarqube=true --overwrite=true

#helm install -f ~/devsecops/sonarqube/sonarqube-values.yaml -n sonarqube sonarqube ./

echo "Your Sonarqube instance is provisioning...."
while [ `kubectl get sts -n sonarqube | grep 1/1 | wc -l` -ne 2 ]
do
  sleep 10
  echo "Wait while sonarqube is still provisioning..."
  kubectl get sts -n sonarqube
done

source $HOME/mylab_vm_prefix.sh

export NODE_IP=`cat ../../mylab_vm_list.txt | grep $VM_PREFIX-devsecops-w1 | cut -d '|' -f 4 | xargs`
export NODE_PORT=$(kubectl get --namespace sonarqube -o jsonpath="{.spec.ports[0].nodePort}" services sonarqube-sonarqube)

echo
echo "Your Sonarqube instance is ready ..." > ~/mysonarqube.txt
echo http://$NODE_IP:$NODE_PORT/login >> ~/mysonarqube.txt
echo username: admin >> ~/mysonarqube.txt
echo initial password: admin >> ~/mysonarqube.txt
echo
cat ~/mysonarqube.txt
