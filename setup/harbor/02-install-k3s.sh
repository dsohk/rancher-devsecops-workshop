#! /bin/bash -e

# Step 1 - Install K3S
echo "Installing k3s ...."
export INSTALL_K3S_VERSION="v1.21.1+k3s1"
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s -
mkdir -p $HOME/.kube 
cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config 
chmod 644 $HOME/.kube/config

# Step 2 - Check if the k3s is ready
# The output should be something like below.
# ec2-user@ip-172-26-3-83:~> kubectl get po -A
# NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
# kube-system   coredns-7448499f4d-4x8ws                  1/1     Running     0          64s
# kube-system   metrics-server-86cbb8457f-zv6mv           1/1     Running     0          64s
# kube-system   local-path-provisioner-5ff76fc89d-2tsnn   1/1     Running     0          64s
# kube-system   helm-install-traefik-crd-gk4ll            0/1     Completed   0          64s
# kube-system   helm-install-traefik-wq7v5                0/1     Completed   1          64s
# kube-system   svclb-traefik-pnx4w                       2/2     Running     0          30s
# kube-system   traefik-97b44b794-zgbht                   1/1     Running     0          30s
echo "Wait while initializing k3s cluster ..."
while [ `kubectl get deploy -n kube-system | grep 1/1 | wc -l` -ne 4 ]
do
  sleep 5
  kubectl get po -n kube-system
done

# Step 3 - ready
echo "Your k3s cluster is ready!"
kubectl get node



