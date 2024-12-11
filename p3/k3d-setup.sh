#!/bin/bash
set -e

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https


# Install Docker
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# sudo chmod a+r /etc/apt/keyrings/docker.gpg

# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
#   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# sudo apt-get update -y
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# sudo systemctl enable docker
# sudo systemctl start docker
# sudo docker --version


# Install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "Creating k3d cluster 'dev'..."
if k3d cluster list | grep -q "dev"; then
    echo "Cluster 'dev' already exists. Deleting it..."
    k3d cluster delete dev
fi

echo "Creating k3d cluster 'dev'..."
k3d cluster create dev

# Configure kubectl for the k3d cluster
export KUBECONFIG=$(k3d kubeconfig write dev)

kubectl get nodes

# Install Argo CD in 'argocd' Namespace
echo "Installing Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for Argo CD Pods to Start
echo "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd

echo "Applying deployment.yaml..."
kubectl create namespace dev
kubectl apply -n dev -f deployment.yaml

kubectl get all -n dev
echo "Script execution completed successfully!"
