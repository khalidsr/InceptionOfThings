#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y curl

# curl -sfL https://get.k3s.ioL | sh -s - server --write-kubeconfig-mode 644
K3S_INSTALL_URL="https://get.k3s.io"
KUBECONFIG_MODE=644
curl -sfL $K3S_INSTALL_URL | sh -s - server --write-kubeconfig-mode $KUBECONFIG_MODE
sudo k3s kubectl get nodes

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
echo "k3s master setup complete."
