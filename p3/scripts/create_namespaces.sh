#!/bin/bash

#create the dev namespace
sudo kubectl create namespace dev

#apply the service configuration
sudo kubectl apply -f ./confs/app/app.yaml -n dev


#initiate the argo cd namespace
sudo kubectl create namespace argocd


#install the argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#expose the argocd server

sleep 10
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443

