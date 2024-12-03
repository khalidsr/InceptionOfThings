#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y

sudo apt-get install curl -y

curl -sfL https://get.k3s.io | sh -

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token

sudo apt-get install snapd -y

sudo snap install kubectl --classic

echo "Everthing installed correctly!"
