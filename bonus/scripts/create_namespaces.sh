#!/bin/bash

#initiate the argo cd namespace
sudo kubectl create namespace argocd

#create the dev namespace
sudo kubectl create namespace dev

sudo kubectl create namespace gitlab

#apply the service configuration
sudo kubectl apply -f ./confs/app/app.yaml -n dev

#install the argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#expose the argocd server

sleep 30
sudo kubectl port-forward svc/argocd-server -n argocd 443:443

# sudo cat /etc/gitlab/initial_root_password 