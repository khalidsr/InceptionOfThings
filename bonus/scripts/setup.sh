#!/bin/bash

set -e

# Install Docker
echo "Installing Docker..."
sudo apt-get update -y
sudo apt-get install -y docker.io

# Install K3d
echo "Installing K3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#k3s installation
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Create K3d cluster
echo "Creating Kubernetes cluster with K3d..."
sudo k3d cluster create gitlab-cluster --api-port 6443 --servers 1 --agents 2 --port 80:80@loadbalancer --port 443:443@loadbalancer

# Verify cluster
echo "Verifying Kubernetes cluster..."
sudo kubectl get nodes

# Create namespace for GitLab
echo "Creating namespace for GitLab..."
sudo kubectl create namespace gitlab

# Add Helm repository for GitLab
echo "Adding GitLab Helm repository..."
sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update

# Install GitLab using Helm
#echo "Installing GitLab..."
#sudo helm install gitlab gitlab/gitlab \
#  --namespace gitlab \
#  --set global.hosts.domain=local \
#  --set global.hosts.externalIP=127.0.0.1 \
#  --set gitlab-runner.install=false

# Wait for GitLab to be ready
#echo "Waiting for GitLab to become ready. This may take a while..."
#sudo kubectl rollout status deployment/gitlab-webservice-default -n gitlab

echo -e "\nGitLab setup completed successfully."

