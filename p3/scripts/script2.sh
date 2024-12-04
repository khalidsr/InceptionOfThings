#!/bin/bash
echo -e "Creting Namespaces..."
if ! command -v docker &> /dev/null; then
    sudo kubectl create  namespace argocd 
    sudo kubectl create  namespace dev
else
    echo -e "Namespaces was creating."
fi
