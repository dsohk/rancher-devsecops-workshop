#! /bin/bash -ex

read -p "Rancher URL: " RANCHER_URL
read -p "Rancher token: " RANCHER_TOKEN

# download rancher client
if [[ ! -f "/usr/local/bin/rancher" ]]; then
  wget https://releases.rancher.com/cli2/v2.4.11/rancher-linux-amd64-v2.4.11.tar.gz -O rancher.tar.gz
  tar xvf rancher.tar.gz
  sudo mv ./rancher-v2.4.11/rancher /usr/local/bin/
  sudo rm -rf ./rancher-v2.4.11/
  sudo rm rancher.tar.gz
fi

# establish session
echo "Connecting to Rancher URL: ${RANCHER_URL} ..."
echo "Rancher Token: ${RANCHER_TOKEN}"
rancher login --skip-verify --token $RANCHER_TOKEN $RANCHER_URL

# provision devsecops RKE
rancher clusters create devsecops

RKE_HOSTNAME=devsecops-m1
ADDNODE_SCRIPT=`rancher clusters add-node --controlplane --etcd -q devsecops`
ADDNODE_SCRIPT="${ADDNODE_SCRIPT} --node-name ${RKE_HOSTNAME} &"
ssh $RKE_HOSTNAME '${ADDNODE_SCRIPT}'

RKE_HOSTNAME=devsecops-w1
ADDNODE_SCRIPT=`rancher clusters add-node --worker -q devsecops`
ADDNODE_SCRIPT="${ADDNODE_SCRIPT} --node-name ${RKE_HOSTNAME} &"
ssh $RKE_HOSTNAME '${ADDNODE_SCRIPT}'

RKE_HOSTNAME=devsecops-w2
ADDNODE_SCRIPT=`rancher clusters add-node --worker -q devsecops`
ADDNODE_SCRIPT="${ADDNODE_SCRIPT} --node-name ${RKE_HOSTNAME} &"
ssh $RKE_HOSTNAME '${ADDNODE_SCRIPT}'

RKE_HOSTNAME=devsecops-w3
ADDNODE_SCRIPT=`rancher clusters add-node --worker -q devsecops`
ADDNODE_SCRIPT="${ADDNODE_SCRIPT} --node-name ${RKE_HOSTNAME} &"
ssh $RKE_HOSTNAME '${ADDNODE_SCRIPT}'

# provision cluster1 RKE
rancher clusters create cluster1

RKE_HOSTNAME=cluster1
ADDNODE_SCRIPT=`rancher clusters add-node --controlplane --etcd -q cluster1`
ADDNODE_SCRIPT="${ADDNODE_SCRIPT} --node-name ${RKE_HOSTNAME} &"
ssh $RKE_HOSTNAME '${ADDNODE_SCRIPT}'

# provision cluster2 RKE
rancher clusters create cluster2

RKE_HOSTNAME=cluster2
ADDNODE_SCRIPT=`rancher clusters add-node --controlplane --etcd -q cluster2`
ADDNODE_SCRIPT="${ADDNODE_SCRIPT} --node-name ${RKE_HOSTNAME} &"
ssh $RKE_HOSTNAME '${ADDNODE_SCRIPT}'


