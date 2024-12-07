#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y curl

curl -sfL https://get.k3s.io | sh -
sudo k3s kubectl get nodes

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
echo "k3s master setup complete."
