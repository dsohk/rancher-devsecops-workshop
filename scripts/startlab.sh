#! /bin/bash

export TAG=demo

# Supported AWS Lighsail Regions: 
# https://lightsail.aws.amazon.com/ls/docs/en_us/articles/understanding-regions-and-availability-zones-in-amazon-lightsail
export AWS_REGION=ap-southeast-1
export AWS_AZ=${AWS_REGION}a

# Instance Sizes
# medium_2_0 => 4GB RAM
# large_2_0 => 8GB RAM

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
    --user-data "systemctl enable docker;systemctl start docker;" \
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

create-vm demo-rancher medium_2_0
create-vm demo-harbor  medium_2_0
create-vm demo-devsecops-m1 medium_2_0
create-vm demo-devsecops-w1 large_2_0
create-vm demo-devsecops-w2 large_2_0
create-vm demo-devsecops-w3 large_2_0
create-vm demo-cluster1 medium_2_0
create-vm demo-cluster2 medium_2_0

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

