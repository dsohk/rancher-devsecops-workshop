#! /bin/bash

# configure docker client to access insecure harbor instance

export HARBOR_IP=`curl http://checkip.amazonaws.com`
export HARBOR_PORT=30443
export HARBOR_URL=${HARBOR_IP}:${HARBOR_PORT}

sudo sed -i "2 i   \"insecure-registries\": [\"${HARBOR_URL}\"]," /etc/docker/daemon.json
sudo systemctl restart docker

sudo mkdir -p /etc/docker/certs.d/demo-harbor
openssl s_client -showcerts -connect $HARBOR_URL < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt
sudo mv ca.crt /etc/docker/certs.d/demo-harbor

cat harbor-credentials.txt

sudo docker login $HARBOR_URL

