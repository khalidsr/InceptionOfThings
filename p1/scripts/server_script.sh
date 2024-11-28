#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
sudo apt-get install -y curl
curl -sfL https://get.k3s.io | sh -


echo "Saving K3s node token to /vagrant"
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
echo "done"
