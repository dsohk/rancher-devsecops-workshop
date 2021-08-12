#! /bin/bash

export TAG=demo

# Supported AWS Lighsail Regions: 
# https://lightsail.aws.amazon.com/ls/docs/en_us/articles/understanding-regions-and-availability-zones-in-amazon-lightsail

# Instance Sizes
# medium = 4GB RAM; large = 8GB RAM
# aws lightsail get-bundles

# JAPAN/TOKYO
# export AWS_REGION=ap-northeast-1
# export AWS_AZ=${AWS_REGION}a
# export VM_SIZE_MEDIUM=medium_2_0
# export VM_SIZE_LARGE=large_2_0

# # SINGAPORE
# export AWS_REGION=ap-southeast-1
# export AWS_AZ=${AWS_REGION}a
# export VM_SIZE_MEDIUM=medium_2_0
# export VM_SIZE_LARGE=large_2_0
# 
# # AUSTRALIA/SYDNEY
# export AWS_REGION=ap-southeast-2
# export AWS_AZ=${AWS_REGION}a
# export VM_SIZE_MEDIUM=medium_2_2
# export VM_SIZE_LARGE=large_2_2
# 
# # INDIA/MUMBAI
export AWS_REGION=ap-south-1
export AWS_AZ=${AWS_REGION}a
export VM_SIZE_MEDIUM=medium_2_1
export VM_SIZE_LARGE=large_2_1


# CreateVM
# First argument - vm-name
# Second argument - instance size
function create-vm() {
  aws lightsail create-instances \
    --region $AWS_REGION \
    --instance-names $1 \
    --availability-zone $AWS_AZ \
    --blueprint-id opensuse_15_2 \
    --bundle-id $2 \
    --ip-address-type ipv4 \
    --user-data "systemctl enable docker;systemctl start docker" \
    --tags key=$TAG \
    --no-cli-pager
}

# Open Network Port for VM
# First argument - vm-name
function configure-vm-network-port() {
  aws lightsail put-instance-public-ports \
    --port-infos \
    "fromPort=22,toPort=22,protocol=TCP" \
    "fromPort=80,toPort=80,protocol=TCP" \
    "fromPort=443,toPort=443,protocol=TCP" \
    "fromPort=8,toPort=-1,protocol=ICMP" \
    --instance-name $1 --output table --no-cli-pager
}

# List all VM
function list-vm() {
  aws lightsail get-instances \
    --region $AWS_REGION \
    --query 'instances[].{publicIpAddress:publicIpAddress,privateIpAddress:privateIpAddress,VMname:name,state:state.name}' \
    --output table --no-cli-pager
}

create-vm demo-rancher $VM_SIZE_MEDIUM
create-vm demo-harbor  $VM_SIZE_MEDIUM
create-vm demo-devsecops-m1 $VM_SIZE_MEDIUM
create-vm demo-devsecops-w1 $VM_SIZE_LARGE
create-vm demo-devsecops-w2 $VM_SIZE_LARGE
create-vm demo-devsecops-w3 $VM_SIZE_LARGE
create-vm demo-cluster1 $VM_SIZE_MEDIUM
create-vm demo-cluster2 $VM_SIZE_MEDIUM

# wait until all VMs are running
sleep 30s

configure-vm-network-port demo-rancher
configure-vm-network-port demo-harbor
configure-vm-network-port demo-devsecops-m1
configure-vm-network-port demo-devsecops-w1
configure-vm-network-port demo-devsecops-w2
configure-vm-network-port demo-devsecops-w3
configure-vm-network-port demo-cluster1
configure-vm-network-port demo-cluster2

# list all VM status with IP addresses
list-vm

