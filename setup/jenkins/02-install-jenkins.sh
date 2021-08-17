#! /bin/bash -e

export KUBECONFIG=$HOME/devsecops.cfg
source $HOME/myharbor.sh

echo Create jenkins namespace
kubectl create ns jenkins

echo Create service account for jenkins
kubectl apply -f https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml

echo Add jenkins helm repo
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm search repo jenkinsci

echo Customize jenkins-values.yaml
cat jenkins-values-template.yaml > my-jenkins-values.yaml
helm install jenkins jenkinsci/jenkins -n jenkins -f my-jenkins-values.yaml 

# admin password
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo


