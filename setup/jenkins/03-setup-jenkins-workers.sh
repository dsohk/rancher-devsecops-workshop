#! /bin/bash -e

export KUBECONFIG=$HOME/.kube/devsecops.cfg
source $HOME/myharbor.sh

# Create jenkins-workers namespace
kubectl create ns jenkins-workers

# Create PVC for m2 (java maven2 PV)
echo "Create PVC m2 (java maven2)..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: m2
  namespace: jenkins-workers
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 5Gi
EOF

# Create configmap for docker-config
echo "Create configmap docker-config ..."
sudo cat /root/.docker/config.json > $PWD/config.json
kubectl create configmap docker-config --from-file=config.json -n jenkins-workers

# CA bundle
echo "Create secret ca-bundle ..."
openssl s_client -showcerts -connect $HARBOR_URL < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > additional-ca-cert-bundle.crt
kubectl create secret generic ca-bundle --from-file=additional-ca-cert-bundle.crt -n jenkins-workers

# clean up
rm -f config.json
rm -f additional-ca-cert-bundle.crt

# show Jenkins information
echo
echo --------------------------------
echo Your Jenkins instance is ready
echo 
cat $HOME/myjenkins.txt
echo

