#!/bin/bash

echo -e "Creating namespaces..."

if ! kubectl get namespace argocd &> /dev/null; then
    echo -e "Namespace 'argocd' does not exist. Creating..."
    kubectl create namespace argocd
else
    echo -e "Namespace 'argocd' already exists."
fi


echo -e "Applying Argo CD manifest..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


if ! kubectl get namespace dev &> /dev/null; then
    echo -e "Namespace 'dev' does not exist. Creating..."
    kubectl create namespace dev
    kubectl apply -f ../app/app.yaml -n dev
else
    echo -e "Namespace 'dev' already exists."
fi


if ! kubectl get namespace gitlab &> /dev/null; then
    echo -e "Namespace 'gitlab' does not exist. Creating..."
    kubectl create namespace gitlab
    helm upgrade --install gitlab gitlab/gitlab --namespace gitlab --values value.yaml
    # kubectl apply -f ./apps/app.yaml -n gitlab
else
    echo -e "Namespace 'gitlab' already exists."
fi

# kubectl port-forward svc/argocd-server -n argocd 8080:443

echo -e "Setup completed successfully."