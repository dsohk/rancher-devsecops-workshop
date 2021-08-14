#! /bin/bash

cat _banner.txt
source mylab_aws_region.sh
source _awsls_functions.sh
echo
echo "Welcome to SUSE Rancher DevSecOps Hands-on Lab on AWS Lightsail ..."
echo

function cleanup() {
  delete-vm demo-rancher
  delete-vm demo-harbor
  delete-vm demo-devsecops-m1 
  delete-vm demo-devsecops-w1
  delete-vm demo-devsecops-w2
  delete-vm demo-devsecops-w3
  delete-vm demo-cluster1
  delete-vm demo-cluster2
  rm {mylab.*,mylab*.txt}
  echo "Your lab environment has been cleaned up."
}

echo "This script will clean up all the VMs provisioned in your AWS Lightsail environment."
read -p "Continue (y/n)?" choice
case "$choice" in 
  y|Y ) cleanup;; 
  n|N ) echo "Aborted.";;
  *   ) echo "invalid";;
esac

