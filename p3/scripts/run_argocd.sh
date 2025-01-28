#! /bin/bash

sudo kubectl apply -f ./confs/argo.yaml -n argocd

# sudo kubectl port-forward svc/service-will42 -n dev 8888:8888