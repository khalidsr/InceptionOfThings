#!/bin/bash

echo -e "Creating namespaces..."

if ! kubectl get namespace argocd &> /dev/null; then
    echo -e "Namespace 'argocd' does not exist. Creating..."
    sudo kubectl create namespace argocd
else
    echo -e "Namespace 'argocd' already exists."
fi


echo -e "Applying Argo CD manifest..."
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


if ! kubectl get namespace dev &> /dev/null; then
    echo -e "Namespace 'dev' does not exist. Creating..."
    sudo kubectl create namespace dev
    sudo kubectl apply -f ./apps/app.yaml -n dev
else
    echo -e "Namespace 'dev' already exists."
fi


if ! kubectl get namespace gitlab &> /dev/null; then
    echo -e "Namespace 'gitlab' does not exist. Creating..."
    sudo kubectl create namespace gitlab
    # helm upgrade --install gitlab gitlab/gitlab --namespace gitlab --values ../confs/values.yaml
    # sudo kubectl apply -f ./apps/app.yaml -n gitlab
else
    echo -e "Namespace 'gitlab' already exists."
fi

# sudo kubectl port-forward svc/argocd-server -n argocd 8080:443

echo -e "Setup completed successfully."
