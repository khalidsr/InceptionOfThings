#!/bin/bash

sudo apt-get update -y

sudo apt-get install curl -y

curl -sfL https://get.k3s.io | sh -

K3S_URL="https://192.168.56.110:6443/"

TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)

curl -sfL https://get.k3s.io/ | K3S_URL=$K3S_URL K3S_TOKEN=$TOKEN sh -

echo "Everthing is well setup!"
