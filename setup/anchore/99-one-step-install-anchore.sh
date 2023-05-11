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

helm repo add anchore https://charts.anchore.io
helm repo update
helm search repo anchore

helm install anchore anchore/anchore-engine \
  --version 1.24.2 \
  --create-namespace \
  -n anchore \
  --set postgresql.persistence.accessMode='ReadWriteMany'

echo "Your Anchore instance is provisioning...."
while [ `kubectl get deploy -n anchore | grep 1/1 | wc -l` -ne 6 ]
do
  sleep 10
  echo "Wait while anchore is still provisioning..."
  kubectl get deploy -n anchore
done

# Get initial password for anchore
ANCHORE_PWD=$(kubectl get secret --namespace anchore anchore-anchore-engine-admin-pass -o jsonpath="{.data.ANCHORE_ADMIN_PASSWORD}" | base64 --decode; echo)

echo
echo "Your Anchore is now successfully provisioned." > $HOME/myanchore.txt
echo "URL: http://anchore-anchore-engine-api.anchore.svc.cluster.local:8228/v1/" >> $HOME/myanchore.txt
echo "User: admin" >> $HOME/myanchore.txt
echo "Password: $ANCHORE_PWD" >> $HOME/myanchore.txt
cat $HOME/myanchore.txt


ANCHORE_CLI_USER=admin
ANCHORE_CLI_PASS=$(kubectl get secret --namespace anchore anchore-anchore-engine-admin-pass -o jsonpath="{.data.ANCHORE_ADMIN_PASSWORD}" | base64 --decode; echo)
ANCHORE_CLI_URL=http://anchore-anchore-engine-api.anchore.svc.cluster.local:8228/v1/

kubectl run -i --tty anchore-cli \
  --restart=Always \
  --image anchore/engine-cli  \
  --env ANCHORE_CLI_USER=${ANCHORE_CLI_USER} \
  --env ANCHORE_CLI_PASS=${ANCHORE_CLI_PASS} \
  --env ANCHORE_CLI_URL=${ANCHORE_CLI_URL} \
  -n anchore

  
kubectl exec -it anchore-cli -n anchore -- bash   


anchore-cli policy list
# anchore-cli policy get 2c53a13c-1765-11e8-82ef-23527761d060 --detail > policybundle.json
anchore-cli policy add policybundle.json
anchore-cli policy activate 2c53a13c-1765-11e8-82ef-23527761d060