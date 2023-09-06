#! /bin/bash -e

# Install Kubernetes tools
echo "Installing Kubernetes Client Tools - kubectl and helm ..."

curl -sLS https://get.arkade.dev | sudo sh

ark get helm
sudo mv /home/ec2-user/.arkade/bin/helm /usr/local/bin/

ark get kubectl
sudo mv /home/ec2-user/.arkade/bin/kubectl /usr/local/bin/


