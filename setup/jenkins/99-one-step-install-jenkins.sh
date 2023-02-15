#! /bin/bash -e

for vm in rancher devsecops-m1 devsecops-w1 devsecops-w2 cluster1 cluster2; do
  echo
  echo "Distribute the self-signed harbor certs to $vm ..."
  scp $HOME/myharbor.sh $vm:~
  scp $HOME/04-configure-containerd-registry.sh $vm:~/configure-containerd-node.sh
  ssh $vm "sudo ./configure-containerd-node.sh"
done

#! /bin/bash -e

source $HOME/myharbor.sh

echo "Login to Harbor private registry ..."
sudo docker login $HARBOR_URL -u $HARBOR_USR -p $HARBOR_PWD

# Uncomment the 3 lines below if you want to build your own plugin here with docker build
# echo "Build my jenkins image with my own plugins..."
# sudo docker build -t myjenkins:v1.0 -f Dockerfile.x86 .
# sudo docker tag myjenkins:v1.0 $HARBOR_URL/library/myjenkins:v1.0

echo "To save time, pull the prebuilt myjenkins docker image ..."
sudo docker pull susesamples/myjenkins:v1.0
sudo docker tag susesamples/myjenkins:v1.0 $HARBOR_URL/library/myjenkins:v1.0

echo "Upload myjenkins image to Harbor private registry ..."
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
sed "s/HARBOR_URL/$HARBOR_URL/g" jenkins-values-template.yaml > my-jenkins-values.yaml

helm install jenkins jenkinsci/jenkins --version 4.2.17 -n jenkins -f my-jenkins-values.yaml

echo "Your Jenkins instance is provisioning...."
while [ `kubectl get sts -n jenkins | grep 1/1 | wc -l` -ne 1 ]
do
  sleep 10
  echo "Wait while jenkins is still provisioning..."
  kubectl get sts -n jenkins
done

source $HOME/mylab_vm_prefix.sh

export NODE_IP=`cat ../../mylab_vm_list.txt | grep $VM_PREFIX-devsecops-w1 | cut -d '|' -f 4 | xargs`
export NODE_PORT=$(kubectl get --namespace jenkins -o jsonpath="{.spec.ports[0].nodePort}" services jenkins)

# admin password
export JENKINS_PWD=$(kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo)

echo
echo "Your Jenkins instance is ready ..." > $HOME/myjenkins.txt
echo http://$NODE_IP:$NODE_PORT/login >> $HOME/myjenkins.txt
echo Username: admin >> $HOME/myjenkins.txt
echo Password: $JENKINS_PWD >> $HOME/myjenkins.txt
echo >> $HOME/myjenkins.txt
echo "Your Jenkins Github webhook Payload URL:" >> $HOME/myjenkins.txt
echo "http://$NODE_IP:$NODE_PORT/github-webhook/" >> $HOME/myjenkins.txt

echo
cat $HOME/myjenkins.txt

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
  storageClassName: "longhorn"
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
