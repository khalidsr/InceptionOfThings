#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
sudo apt-get install -y curl
echo "Waiting for /vagrant/node-token from the controller"

while [ ! -f /vagrant/node-token ]; do
  sleep 2
done


NODE_TOKEN=$(cat /vagrant/node-token)
SERVER_IP="192.168.56.110"
echo ${NODE_TOKEN}"--------------"
curl -sfL https://get.k3s.io | K3S_URL=https://${SERVER_IP}:6443 K3S_TOKEN=${NODE_TOKEN} sh -


echo "done"
