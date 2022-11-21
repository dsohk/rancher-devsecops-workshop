#! /bin/bash -e

# Install Kubernetes tools
echo "Installing Kubernetes Client Tools - kubectl and helm ..."

curl -sLS https://dl.get-arkade.dev | sh
sudo mv arkade /usr/local/bin/arkade
sudo ln -sf /usr/local/bin/arkade /usr/local/bin/ark

ark get helm
sudo mv /home/ec2-user/.arkade/bin/helm /usr/local/bin/

ark get kubectl
sudo mv /home/ec2-user/.arkade/bin/kubectl /usr/local/bin/


#! /bin/bash -e

# Step 1 - Install K3S
echo "Installing k3s ...."
#export INSTALL_K3S_VERSION="v1.24"
export INSTALL_K3S_CHANNEL="v1.24"
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s -
mkdir -p $HOME/.kube
cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
chmod 644 $HOME/.kube/config

# Step 2 - Check if the k3s is ready
# The output should be something like below.
# ec2-user@ip-172-26-3-83:~> kubectl get po -A
# NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
# kube-system   coredns-7448499f4d-4x8ws                  1/1     Running     0          64s
# kube-system   metrics-server-86cbb8457f-zv6mv           1/1     Running     0          64s
# kube-system   local-path-provisioner-5ff76fc89d-2tsnn   1/1     Running     0          64s
# kube-system   helm-install-traefik-crd-gk4ll            0/1     Completed   0          64s
# kube-system   helm-install-traefik-wq7v5                0/1     Completed   1          64s
# kube-system   svclb-traefik-pnx4w                       2/2     Running     0          30s
# kube-system   traefik-97b44b794-zgbht                   1/1     Running     0          30s
echo "Wait while initializing k3s cluster ..."
while [ `kubectl get deploy -n kube-system | grep 1/1 | wc -l` -ne 4 ]
do
  sleep 5
  kubectl get po -n kube-system
done

# Step 3 - ready
echo "Your k3s cluster is ready!"
kubectl get node



#! /bin/bash -e

# Install harbor with helm chart

echo "Deploying harbor on k3s ...."
export KUBECONFIG=$HOME/.kube/config
kubectl create ns harbor
helm repo add harbor https://helm.goharbor.io
helm repo update
helm search repo harbor

export HARBOR_IP=`curl -sq http://checkip.amazonaws.com`
export HARBOR_ADMIN_PWD=`tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -n1`
export HARBOR_NODEPORT=30443

helm install harbor-registry harbor/harbor --version 1.10.2 \
  -n harbor \
  --set expose.type=nodePort \
  --set expose.nodePort.ports.https.nodePort=${HARBOR_NODEPORT} \
  --set expose.tls.auto.commonName=demo-harbor \
  --set externalURL=https://${HARBOR_IP}:${HARBOR_NODEPORT} \
  --set harborAdminPassword="${HARBOR_ADMIN_PWD}"

# Output should be like this when it's completed.
# ec2-user@ip-172-26-3-222:~> kubectl get po -n harbor
# NAME                                                    READY   STATUS    RESTARTS   AGE
# harbor-registry-harbor-portal-fc7869f46-kt9j2           1/1     Running   0          82s
# harbor-registry-harbor-nginx-b9df69d4f-6x6kd            1/1     Running   0          82s
# harbor-registry-harbor-redis-0                          1/1     Running   0          82s
# harbor-registry-harbor-chartmuseum-db5657f9c-ldrkp      1/1     Running   0          82s
# harbor-registry-harbor-database-0                       1/1     Running   0          82s
# harbor-registry-harbor-notary-server-85b6b59986-4k8dq   1/1     Running   1          82s
# harbor-registry-harbor-notary-signer-7d8bbbb6d4-l28pm   1/1     Running   1          82s
# harbor-registry-harbor-registry-64ddb659db-t7bxm        2/2     Running   0          82s
# harbor-registry-harbor-trivy-0                          1/1     Running   0          82s
# harbor-registry-harbor-core-66bcd59b97-h5t94            1/1     Running   0          82s
# harbor-registry-harbor-jobservice-7fbf95459b-hc2mh      1/1     Running   0          82s

echo "Your Harbor instance is provisioning...."
while [ `kubectl get deploy -n harbor | grep 1/1 | wc -l` -ne 8 ]
do
  sleep 10
  echo "Wait while harbor is still provisioning..."
  kubectl get deploy  -n harbor
done

# save the harbor credential for use at later stage
echo "export HARBOR_URL=${HARBOR_IP}:${HARBOR_NODEPORT}" > myharbor.sh
echo "export HARBOR_USR=admin" >> myharbor.sh
echo "export HARBOR_PWD=${HARBOR_ADMIN_PWD}" >> myharbor.sh

echo "Your Harbor Instance is ready ..." > harbor-credential.txt
echo "URL: https://${HARBOR_IP}:${HARBOR_NODEPORT}" >> harbor-credential.txt
echo "User: admin" >> harbor-credential.txt
echo "Password: ${HARBOR_ADMIN_PWD}" >> harbor-credential.txt
echo "Your login credential is saved in a file: harbor-credential.txt"
cat harbor-credential.txt



#! /bin/bash

source $HOME/myharbor.sh

echo "Configure docker client to access harbor instance with self-signed cert ..."
sudo sed -i "2 i   \"insecure-registries\": [\"https://${HARBOR_URL}\"]," /etc/docker/daemon.json
sudo systemctl restart docker

echo "Download Harbor CA cert into /etc/docker/certs.d/demo-harbor folder ..."
sudo mkdir -p /etc/docker/certs.d/demo-harbor
openssl s_client -showcerts -connect $HARBOR_URL < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt
sudo mv ca.crt /etc/docker/certs.d/demo-harbor

echo "Login to harbor with docker client ..."
sudo docker login $HARBOR_URL -u $HARBOR_USR -p $HARBOR_PWD

#! /bin/bash -e

echo "Download docker images for sample application build..."

source $HOME/myharbor.sh

sudo docker pull maven:3-jdk-8-slim
sudo docker tag maven:3-jdk-8-slim $HARBOR_URL/library/java/maven:3-jdk-8-slim
sudo docker push $HARBOR_URL/library/java/maven:3-jdk-8-slim

sudo docker pull susesamples/sles15sp3-openjdk:11.0-3.56.1
sudo docker tag susesamples/sles15sp3-openjdk:11.0-3.56.1 $HARBOR_URL/library/suse/sles15sp3-openjdk:11.0-3.56.1
sudo docker push $HARBOR_URL/library/suse/sles15sp3-openjdk:11.0-3.56.1

echo
echo
echo ============================================================
echo "Congrats! Your Harbor instance has been setup successfully."
cat harbor-credential.txt
echo
