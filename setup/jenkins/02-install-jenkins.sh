#! /bin/bash -e

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

source ../../myharbor.sh

echo Create jenkins namespace
kubectl create ns jenkins

echo Create service account for jenkins
kubectl apply -f https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml

echo Add jenkins helm repo
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm search repo jenkinsci

echo Customize jenkins-values.yaml
sed "s/HARBOR_URL/$HARBOR_URL/g" jenkins-values-template.yaml > my-jenkins-values.yaml

helm install jenkins jenkinsci/jenkins -n jenkins -f my-jenkins-values.yaml

echo "Your Jenkins instance is provisioning...."
while [ `kubectl get sts -n jenkins | grep 1/1 | wc -l` -ne 1 ]
do
  sleep 10
  echo "Wait while jenkins is still provisioning..."
  kubectl get sts -n jenkins
done

export NODE_IP=`cat ../../mylab_vm_list.txt | grep suse0908-devsecops-w1 | cut -d '|' -f 4 | xargs`
export NODE_PORT=$(kubectl get --namespace jenkins -o jsonpath="{.spec.ports[0].nodePort}" services jenkins)

# admin password
export JENKINS_PWD=$(kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password)

echo
echo "Your Jenkins instance is ready ..." > ~/myjenkins.txt
echo http://$NODE_IP:$NODE_PORT/login >> ~/myjenkins.txt
echo Username: admin >> ~/myjenkins.txt
echo Password: $JENKINS_PWD >> ~/myjenkins.txt
echo
cat ~/myjenkins.txt

