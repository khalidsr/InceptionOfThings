#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y curl
apt install net-tools -y

curl -sfL https://get.k3s.io | sh -



echo "Waiting for K3s to be ready..."
while ! kubectl get nodes &> /dev/null; do
    sleep 5
done
echo "K3s is ready."


echo "Applying Kubernetes manifests..."
kubectl apply -f ./confs/configmap_app1.yaml --validate=false
kubectl apply -f ./confs/configmap_app2.yaml --validate=false
kubectl apply -f ./confs/configmap_app3.yaml --validate=false
kubectl apply -f ./confs/apps/app1/app1.yaml --validate=false
kubectl apply -f ./confs/apps/app2/app2.yaml --validate=false
kubectl apply -f ./confs/apps/app3/app3.yaml --validate=false
kubectl apply -f ./confs/ingress.yaml --validate=false

echo "Deployment completed."