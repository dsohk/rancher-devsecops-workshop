# CreateVM
# First argument - vm-name
# Second argument - instance size
# Third argument - extra cmd for user-data
function create-vm() {

  # Randomly choose availability zone in the selected AWS region ...
  IFS=', ' read -r -a AVAIL_AZ <<< "$AWS_AVAIL_AZ"
  AWS_SELECTED_AZ=${AVAIL_AZ[$RANDOM % ${#AVAIL_AZ[@]} ]}
  AWS_AZ=${AWS_REGION}${AWS_SELECTED_AZ}

  aws lightsail create-instances \
    --region $AWS_REGION \
    --instance-names $1 \
    --availability-zone $AWS_AZ \
    --blueprint-id opensuse_15_2 \
    --bundle-id $2 \
    --ip-address-type ipv4 \
    --user-data "echo 'export PS1=\"$1 \u@\h:\w>\"' >> /home/ec2-user/.bashrc; echo 'export PS1=\"$1 \u@\h:\w>\"' >> /root/.bashrc; $3" \
    --tags key=suse-rancher \
    --output table --no-cli-pager
}

# DeleteVM
# First argument - vm-name
function delete-vm() {
  aws lightsail delete-instance \
    --region $AWS_REGION \
    --instance-name $1 \
    --force-delete-add-ons \
    --output table --no-cli-pager
}

# Open Network Port for VM
# First argument - vm-name
function open-vm-standard-network-port() {
  aws lightsail put-instance-public-ports \
    --port-infos \
    "fromPort=22,toPort=22,protocol=TCP" \
    "fromPort=8,toPort=-1,protocol=ICMP" \
    --instance-name $1 --output table --no-cli-pager
}

# Open specific, not-default network port for VM
# First argument - vm-name
# Second argument - starting network port
# Third argument - ending network port
function open-vm-specific-network-port() {
  aws lightsail open-instance-public-ports \
    --port-info fromPort=$2,toPort=$3,protocol=TCP \
    --instance-name $1 --output table --no-cli-pager
}

# List all VM
function list-vm() {
  aws lightsail get-instances \
    --region $AWS_REGION \
    --query 'instances[].{publicIpAddress:publicIpAddress,privateIpAddress:privateIpAddress,VMname:name,state:state.name}' \
    --output table --no-cli-pager
}

# Get VM Status by name
# first argument - vm name
function get-vm-status() {
  aws lightsail get-instances \
    --region $AWS_REGION \
    --query 'instances[].{publicIpAddress:publicIpAddress,privateIpAddress:privateIpAddress,VMname:name,state:state.name}' \
    --output table --no-cli-pager | grep $1 | cut -d '|' -f 5 | xargs
}

# Get Public IP address of the VM based on the name
# First Argument - vm name
function get-vm-public-ip() {
 aws lightsail get-instances \
    --region $AWS_REGION \
    --query 'instances[].{publicIpAddress:publicIpAddress,privateIpAddress:privateIpAddress,VMname:name,state:state.name}' \
    --output table --no-cli-pager | grep $1 | cut -d '|' -f 4 | xargs
}

# Download key pair from the region
function download-key-pair() {
  aws lightsail download-default-key-pair --output text --query publicKeyBase64 > mylab.pub
  chmod 644 mylab.pub
  aws lightsail download-default-key-pair --output text --query privateKeyBase64 > mylab.key
  chmod 600 mylab.key
}
