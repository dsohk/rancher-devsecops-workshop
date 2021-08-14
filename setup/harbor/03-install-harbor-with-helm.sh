#! /bin/bash -e

# Install harbor with helm chart

export KUBECONFIG=$HOME/.kube/config
kubectl create ns harbor
helm repo add harbor https://helm.goharbor.io
helm repo update
helm search repo harbor

export HARBOR_IP=`curl http://checkip.amazonaws.com`
export HARBOR_ADMIN_PWD=`tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1`
export HARBOR_NODEPORT=30443

helm install harbor-registry harbor/harbor --version 1.6.2 \
  -n harbor \
  --set expose.type=nodePort \
  --set expose.nodePort.ports.https.nodePort=${HARBOR_NODEPORT} \
  --set expose.tls.auto.commonName=demo-harbor \
  --set externalURL=https://${HARBOR_IP}:${HARBOR_NODEPORT} \
  --set harborAdminPassword="${HARBOR_ADMIN_PWD}"

echo "Your Harbor instance is provisioning...."
echo
kubectl get all,pv,pvc -n harbor
echo
echo "URL: https://${HARBOR_IP}:${HARBOR_NODEPORT}" > harbor-credential.txt
echo "User: admin" >> harbor-credential.txt
echo "Password: ${HARBOR_ADMIN_PWD}" >> harbor-credential.txt
echo "Your login credential is saved in a file: harbor-credential.txt"
cat harbor-credential.txt
