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


