#! /bin/bash -e

# install rancher server

sudo mkdir -p /opt/rancher

sudo docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  --privileged \
  -v /opt/rancher:/var/lib/rancher \
  rancher/rancher:v2.5.9 \

