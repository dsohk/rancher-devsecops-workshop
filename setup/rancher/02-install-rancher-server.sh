#! /bin/bash -e

# install rancher server

sudo mkdir -p /opt/rancher

sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  -v /opt/rancher:/var/lib/rancher \
  rancher/rancher:v2.5.9 \

export RANCHER_IP=`curl http://checkip.amazonaws.com`

echo "Please wait for 5-10 mins to initializing Rancher server."

echo "Your Rancher Server URL: https://${RANCHER_IP}" > rancher-url.txt
cat rancher-url.txt

