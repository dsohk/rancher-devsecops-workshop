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

# install rancher server
echo "Install Rancher Server ..."

sudo mkdir -p /opt/rancher

sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  -v /opt/rancher:/var/lib/rancher \
  rancher/rancher:v2.6.0 \

export RANCHER_IP=`curl -qs http://checkip.amazonaws.com`

echo
echo "---------------------------------------------------------"
echo "Please wait for 5-10 mins to initializing Rancher server."
echo
echo "Your Rancher Server URL: https://${RANCHER_IP}" > rancher-url.txt
cat rancher-url.txt
echo

