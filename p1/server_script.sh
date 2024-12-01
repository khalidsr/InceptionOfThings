#! /bin/bash

sudo apt-get update -y

sudo apt-get install curl -y

curl -sfL https://get.k3s.io | sh -

sudo apt-get install snapd -y

sudo snap install kubectl --classic

echo "Everthing installed correctly!"
