#!/bin/bash

set -e

sudo kubectl create namespace argocd

sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl wait --for=condition=available --timeout=300s -n argocd deployment/argocd-server

# To run manually:
#sudo kubectl port-forward svc/argocd-server -n argocd 8080:443

sudo kubectl create namespace dev

sudo kubectl apply -f ../app/deploy.yaml -n dev

sudo kubectl create namespace gitlab

echo "Configuration completed successfully!"
