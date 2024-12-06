#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y curl

while [ ! -f /vagrant/node-token ]; do
  sleep 5
done

K3S_TOKEN=$(cat /vagrant/node-token)
echo "Token retrieved: $K3S_TOKEN"
curl -sfL https://get.k3s.io | K3S_URL="https://192.168.56.110:6443" K3S_TOKEN="$K3S_TOKEN" sh -
echo "k3s agent setup complete."