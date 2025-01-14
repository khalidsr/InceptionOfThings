#!/bin/bash
set -e

echo "Starting environment configuration..."

# Step 1: Create namespaces for Argo CD and application deployment
echo "Creating namespaces for Argo CD and application deployment..."
sudo kubectl create namespace argocd || echo "Namespace 'argocd' already exists."
sudo kubectl create namespace dev || echo "Namespace 'dev' already exists."

# Step 2: Install Argo CD
echo "Installing Argo CD in the 'argocd' namespace..."
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd
echo "Argo CD installed and ready in the 'argocd' namespace."

# Step 3: Deploy application manifests
echo "Applying application deployment configuration..."
sudo kubectl apply -n dev -f ../app/deploy.yaml
sudo kubectl apply -n dev -f ../confs/argocd.yaml
echo "Application successfully deployed. Fetching deployment details..."
sudo kubectl get all -n dev

# Step 4: Expose Argo CD server (optional)
echo "Exposing Argo CD server using port forwarding..."
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443 &
PORT_FORWARD_PID=$!
echo "Port forwarding established. Access Argo CD at http://localhost:8080. To stop port forwarding, terminate PID: $PORT_FORWARD_PID."

echo "Environment configuration completed successfully!"
