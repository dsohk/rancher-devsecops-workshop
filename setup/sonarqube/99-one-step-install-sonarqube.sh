#! /bin/bash -e

export KUBECONFIG=$HOME/.kube/devsecops.cfg

# check if git is installed
git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE -ne 0 ]; then
  sudo zypper install -y git-core
fi

git clone https://github.com/SonarSource/helm-chart-sonarqube.git
cd helm-chart-sonarqube/charts/sonarqube
helm dependency update
kubectl create namespace sonarqube

kubectl taint nodes devsecops-w1 sonarqube=true:NoSchedule --overwrite=true
kubectl label node devsecops-w1  sonarqube=true --overwrite=true

helm install -f ~/devsecops/sonarqube/sonarqube-values.yaml -n sonarqube sonarqube ./

echo "Your Sonarqube instance is provisioning...."
while [ `kubectl get sts -n sonarqube | grep 1/1 | wc -l` -ne 2 ]
do
  sleep 10
  echo "Wait while sonarqube is still provisioning..."
  kubectl get sts -n sonarqube
done

export NODE_IP=`cat $HOME/mylab_vm_list.txt | grep suse0908-devsecops-w1 | cut -d '|' -f 4 | xargs`
export NODE_PORT=$(kubectl get --namespace sonarqube -o jsonpath="{.spec.ports[0].nodePort}" services sonarqube-sonarqube)

echo
echo "Your Sonarqube instance is ready ..." > ~/mysonarqube.txt
echo http://$NODE_IP:$NODE_PORT/login >> ~/mysonarqube.txt
echo username: admin >> ~/mysonarqube.txt
echo initial password: admin >> ~/mysonarqube.txt
echo
cat ~/mysonarqube.txt
