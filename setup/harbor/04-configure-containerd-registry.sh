#! /bin/bash

source /home/ec2-user/myharbor.sh

echo "Configure containerd to access harbor instance with self-signed cert ..."
sudo mkdir -p /etc/rancher/rke2

echo "Download Harbor CA cert into /etc/rancher/rke2/demo-harbor folder ..."
sudo mkdir -p /etc/rancher/rke2/demo-harbor
openssl s_client -showcerts -connect $HARBOR_URL < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt
sudo mv ca.crt /etc/rancher/rke2/demo-harbor

export REGISTRY_YAML=/etc/rancher/rke2/registries.yaml
sudo echo "configs:" > $REGISTRY_YAML
sudo echo "  \"${HARBOR_URL}\":" >> $REGISTRY_YAML
sudo echo "    auth:" >> $REGISTRY_YAML
sudo echo "      username: ${HARBOR_USR}" >> $REGISTRY_YAML
sudo echo "      password: ${HARBOR_PWD}" >> $REGISTRY_YAML
sudo echo "    tls:" >> $REGISTRY_YAML
sudo echo "      ca_file: /etc/rancher/rke2/demo-harbor/ca.crt" >> $REGISTRY_YAML
sudo echo "      insecure_skip_verify: true" >> $REGISTRY_YAML

if sudo systemctl list-units --type=service | grep -q "rke2-server"; then
  echo "Restart rke2-server service ..."
  sudo systemctl restart rke2-server
fi

if sudo systemctl list-units --type=service | grep -q "rke2-agent"; then
  echo "Restart rke2-agent service ..."
  sudo systemctl restart rke2-agent
fi

