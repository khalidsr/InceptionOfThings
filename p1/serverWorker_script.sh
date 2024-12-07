#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y

sudo apt-get install curl -y

while [ ! -e /vagrant/node-token ] 
do
	sleep 1
done

K3S_URL="https://192.168.56.110:6443"

TOKEN=$(cat /vagrant/node-token)

curl -sfL https://get.k3s.io | K3S_URL=${K3S_URL} K3S_TOKEN=${TOKEN} sh -

echo "Everthing is well setup!"
