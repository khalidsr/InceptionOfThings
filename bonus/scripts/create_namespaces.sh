#!/bin/bash

#initiate the argo cd namespace
sudo kubectl create namespace argocd

#create the dev namespace
sudo kubectl create namespace dev

#apply the service configuration
sudo kubectl apply -f ../app/app.yaml -n dev

#install the argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#expose the argocd server
#sudo kubectl -n argocd patch svc argocd-server -n argocd 8080:443
sleep 10
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443
