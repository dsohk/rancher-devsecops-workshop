#! /bin/bash -e

# install rancher server
echo "Install Rancher Server ..."

source $HOME/mylab_rancher_version.sh

sudo mkdir -p /opt/rancher

sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  -v /opt/rancher:/var/lib/rancher \
  rancher/rancher:${RANCHER_VERSION} \

export RANCHER_IP=`curl -qs http://checkip.amazonaws.com`

echo
echo "---------------------------------------------------------"
echo "Please wait for 5-10 mins to initializing Rancher server."
echo
echo "Your Rancher Server URL: https://${RANCHER_IP}" > rancher-url.txt
cat rancher-url.txt
echo

