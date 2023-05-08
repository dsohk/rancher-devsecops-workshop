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

helm repo add neuvector https://neuvector.github.io/neuvector-helm/
helm repo update
helm search repo neuvector/core


helm install neuvector neuvector/core \
  --create-namespace \
  -n neuvector \
  --set tag=5.1.2 \ 
  --set k3s.enabled=true \
  --set manager.svc.type='NodePort'


echo "Your NeuVector instance is provisioning...."
while [ `kubectl get deploy -n neuvector | grep 1/1 | wc -l` -ne 6 ]
do
  sleep 10
  echo "Wait while neuvector is still provisioning..."
  kubectl get deploy -n neuvector
done

# Get initial password for anchore
ANCHORE_PWD=$(kubectl get secret --namespace anchore anchore-anchore-engine-admin-pass -o jsonpath="{.data.ANCHORE_ADMIN_PASSWORD}" | base64 --decode; echo)

echo
echo "Your neuvector is now successfully provisioned." > $HOME/myanchore.txt
echo "URL: http://anchore-anchore-engine-api.anchore.svc.cluster.local:8228/v1/" >> $HOME/myanchore.txt
echo "User: admin" >> $HOME/myanchore.txt
echo "Password: $ANCHORE_PWD" >> $HOME/myanchore.txt
cat $HOME/myanchore.txt


ANCHORE_CLI_USER=admin
ANCHORE_CLI_PASS=admin
ANCHORE_CLI_URL=http://anchore-anchore-engine-api.anchore.svc.cluster.local:8228/v1/


