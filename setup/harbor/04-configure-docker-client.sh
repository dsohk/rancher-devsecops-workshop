#! /bin/bash


export HARBOR_IP=`curl -sq http://checkip.amazonaws.com`
export HARBOR_PORT=30443
export HARBOR_URL=${HARBOR_IP}:${HARBOR_PORT}

echo "Configure docker client to access harbor instance with self-signed cert ..."
sudo sed -i "2 i   \"insecure-registries\": [\"${HARBOR_URL}\"]," /etc/docker/daemon.json
sudo systemctl restart docker

echo "Download Harbor CA cert into /etc/docker/certs.d/demo-harbor folder ..."
sudo mkdir -p /etc/docker/certs.d/demo-harbor
openssl s_client -showcerts -connect $HARBOR_URL < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt
sudo mv ca.crt /etc/docker/certs.d/demo-harbor

echo "Try login to harbor with your credential now ..."
cat harbor-credential.txt

echo 
echo "Enter your harbor admin credential below ..."
echo "docker login $HARBOR_URL"
sudo docker login $HARBOR_URL

