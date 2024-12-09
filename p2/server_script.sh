#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y

sudo apt-get install curl -y

curl -sfL https://get.k3s.io | sh -

sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token

sudo apt-get install snapd -y

sudo snap install kubectl --classic

#commands to run deployment
sudo kubectl apply -f /vagrant/deployment/app1.deployment.yaml
sudo kubectl apply -f /vagrant/deployment/app2.deployment.yaml
sudo kubectl apply -f /vagrant/deployment/app3.deployment.yaml

#commands to run services
sudo kubectl apply -f /vagrant/apps/app1.service.yaml
sudo kubectl apply -f /vagrant/apps/app2.service.yaml
sudo kubectl apply -f /vagrant/apps/app3.service.yaml

#command to apply the ingress
sudo kubectl apply -f /vagrant/ingress.yaml

echo "Everthing installed correctly!"
