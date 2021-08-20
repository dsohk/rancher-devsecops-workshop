#! /bin/bash -e

source ~/myharbor.sh

echo "Build my jenkins image with my own plugins..."
sudo docker build -t myjenkins:v1.0 -f Dockerfile.x86 .

echo "Login to Harbor private registry ..."
sudo docker login $HARBOR_URL -u $HARBOR_USR -p $HARBOR_PWD

echo "Upload myjenkins image to Harbor private registry ..."
sudo docker tag myjenkins:v1.0 $HARBOR_URL/library/myjenkins:v1.0
sudo docker push $HARBOR_URL/library/myjenkins:v1.0


#! /bin/bash -e

export KUBECONFIG=$HOME/.kube/devsecops.cfg
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
# cat jenkins-values-template.yaml > my-jenkins-values.yaml
helm install jenkins jenkinsci/jenkins -n jenkins -f my-jenkins-values.yaml
export NODE_PORT=$(kubectl get --namespace jenkins -o jsonpath="{.spec.ports[0].nodePort}" services jenkins)
export NODE_IP=$(kubectl get nodes --namespace jenkins -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT/login

# admin password
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo

