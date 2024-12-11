#!/bin/bash
set -e

# Update system and install necessary dependencies
echo "Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl

# Install Helm if not installed
if ! command -v helm &> /dev/null
then
    echo "Helm not found, installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
else
    echo "Helm is already installed."
fi

# Add GitLab Helm repository
echo "Adding GitLab Helm repository..."
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# Create a namespace for GitLab in Kubernetes
echo "Creating GitLab namespace..."
kubectl create namespace gitlab

# Install GitLab using Helm
echo "Installing GitLab using Helm..."
helm install gitlab gitlab/gitlab --namespace gitlab --set global.hosts.domain=gitlab.local

# Wait for the pods to be up and running
echo "Waiting for GitLab to deploy..."
kubectl wait --namespace gitlab --for=condition=available --timeout=600s deployment/gitlab

# Expose GitLab (LoadBalancer or NodePort depending on your setup)
echo "Exposing GitLab service..."
kubectl expose pod gitlab-webservice-default --type=LoadBalancer --name=gitlab-service --namespace gitlab

# Get the external IP or localhost depending on the type of service used
echo "GitLab is being exposed, checking access..."
if kubectl get services -n gitlab | grep -q 'LoadBalancer'; then
    EXTERNAL_IP=$(kubectl get svc -n gitlab -o=jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
    echo "GitLab is accessible at http://$EXTERNAL_IP"
else
    echo "GitLab service exposed using NodePort, access it at http://localhost:8080"
fi

# Get the GitLab root password for login
echo "Fetching GitLab initial root password..."
kubectl get secret --namespace gitlab gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}' | base64 --decode; echo
