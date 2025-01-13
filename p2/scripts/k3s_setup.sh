#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y curl

curl -sfL https://get.k3s.io | sh -
sudo k3s kubectl get nodes

sudo kubectl apply -f /vagrant/app1/deployment.yaml
sudo kubectl apply -f /vagrant/app2/deployment.yaml
sudo kubectl apply -f /vagrant/app3/deployment.yaml

sudo kubectl apply -f /vagrant/confs/ingress.yaml
echo "Deployment completed."
