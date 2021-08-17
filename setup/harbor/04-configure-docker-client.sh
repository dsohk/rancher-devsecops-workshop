#! /bin/bash

source myharbor.sh

echo "Configure docker client to access harbor instance with self-signed cert ..."
sudo sed -i "2 i   \"insecure-registries\": [\"https://${HARBOR_URL}\"]," /etc/docker/daemon.json
sudo systemctl restart docker

echo "Download Harbor CA cert into /etc/docker/certs.d/demo-harbor folder ..."
sudo mkdir -p /etc/docker/certs.d/demo-harbor
openssl s_client -showcerts -connect $HARBOR_URL < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt
sudo mv ca.crt /etc/docker/certs.d/demo-harbor

echo "Login to harbor with docker client ..."
sudo docker login $HARBOR_URL -u $HARBOR_USR -p $HARBOR_PWD

echo "Distribute the self-signed harbor certs into other VMs in this lab ..."

echo "Congrats! Your Harbor instance has been setup successfully."
cat harbor-credential.txt

