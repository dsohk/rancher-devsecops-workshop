#! /bin/bash -e

# install rancher server
echo "Install Rancher Server ..."

sudo mkdir -p /opt/rancher

sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  -v /opt/rancher:/var/lib/rancher \
  rancher/rancher:v2.5.9 \

export RANCHER_IP=`curl -qs http://checkip.amazonaws.com`

echo
echo "---------------------------------------------------------"
echo "Please wait for 5-10 mins to initializing Rancher server."
echo
echo "Your Rancher Server URL: https://${RANCHER_IP}" > rancher-url.txt
cat rancher-url.txt
echo

