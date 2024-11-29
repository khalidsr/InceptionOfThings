#!/bin/bash
set -e

chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
sudo systemctl restart sshd

# Variables
K3S_SERVER_IP="192.168.56.110"
SSH_USER="aelasriS"
NODE_TOKEN_FILE="/var/lib/rancher/k3s/server/node-token"


echo "Fetching node token from the server at $K3S_SERVER_IP..."
# Use SSH to fetch the token from the server
NODE_TOKEN=$(ssh -o StrictHostKeyChecking=no ${SSH_USER}@${K3S_SERVER_IP} "sudo cat ${NODE_TOKEN_FILE}")

if [ -z "$NODE_TOKEN" ]; then
    echo "Error: Failed to retrieve the node token from the server."
    exit 1
fi

echo "Node token fetched successfully."

echo "Installing k3s agent..."

sudo apt-get update -y
sudo apt-get install -y curl
curl -sfL https://get.k3s.io | K3S_URL="https://${K3S_SERVER_IP}:6443" K3S_TOKEN="${NODE_TOKEN}" sh -

echo "k3s agent installation complete. Verifying connection..."
sudo k3s-agent kubectl get nodes
