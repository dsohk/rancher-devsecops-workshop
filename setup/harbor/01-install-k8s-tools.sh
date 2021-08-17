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


