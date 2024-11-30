#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y curl

curl -sfL https://get.k3s.io | sh -


export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "Waiting for K3s to be ready..."
while ! sudo kubectl get nodes &> /dev/null; do
    sleep 5
done
echo "K3s is ready."

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

echo "Applying Kubernetes manifests..."
kubectl apply -f ./apps/app1/app1.yaml --validate=false
kubectl apply -f ./apps/app2/app2.yaml --validate=false
kubectl apply -f ./apps/app3/app3.yaml --validate=false
kubectl apply -f ingress.yaml --validate=false

echo "Deployment completed."
