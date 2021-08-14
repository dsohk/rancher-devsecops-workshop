#! /bin/bash -e

kubectl create ns jenkins

kubectl apply -f https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml

helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm search repo jenkinsci

helm install jenkins jenkinsci/jenkins -n jenkins -f jenkins-values.yaml 

# admin password
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo


