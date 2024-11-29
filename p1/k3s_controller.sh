#!/bin/bash
set -e

# Variables
K3S_INSTALL_URL="https://get.k3s.io"
KUBECONFIG_MODE=644

echo "Installing k3s in controller mode..."

sudo apt-get update -y
sudo apt-get install -y curl

curl -sfL $K3S_INSTALL_URL | sh -s - server --write-kubeconfig-mode $KUBECONFIG_MODE

echo "k3s server installed successfully. Verifying installation..."
sudo k3s kubectl get nodes

# Display the node token
echo "Node token for agents to join the cluster:"
cat /var/lib/rancher/k3s/server/node-token

echo "Installation complete. Use the above token to connect agents."
