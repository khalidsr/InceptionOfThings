#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y curl

curl -sfL https://get.k3s.io | sh -
sudo k3s kubectl get nodes
echo "k3s master setup complete."

# sudo kubectl create namespace ingress-nginx
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

sudo kubectl apply -f /vagrant/app1/deployment.yaml
sudo kubectl apply -f /vagrant/app2/deployment.yaml
sudo kubectl apply -f /vagrant/app3/deployment.yaml

echo -e "192.168.56.110    app1.com\n192.168.56.110    app2.com\n192.168.56.110    app3.com" | sudo tee -a /etc/hosts
