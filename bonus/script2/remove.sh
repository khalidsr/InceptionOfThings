#!/bin/bash
sudo kubectl delete deployment  --namespace=gitlab --all 
sudo kubectl delete svc --namespace=gitlab --all  
sudo kubectl delete ingress  --namespace=gitlab --all 
sudo helm uninstall gitlab -n gitlab

# sudo helm upgrade --install gitlab ./gitlab -f gitlab-values.yaml --namespace gitlab
# sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 8181:8181 



# sudo kubectl delete -n argocd all --all
# kubectl get pvc -n gitlab


kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath="{.data.password}" | base64 -d >> passwd.txt