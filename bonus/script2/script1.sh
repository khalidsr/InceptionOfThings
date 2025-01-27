#!/bin/bash

sudo apt update && sudo apt install -y curl wget apt-transport-https ca-certificates software-properties-common

echo -e "Installing Docker..."
if ! command -v docker &> /dev/null; then
    DOCKER_REPO="https://download.docker.com/linux/debian"
    echo "Adding Docker GPG key and repository..."
    curl -fsSL $DOCKER_REPO/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $DOCKER_REPO $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt update
    if ! sudo apt install -y docker-ce docker-ce-cli containerd.io; then
        echo "Falling back to alternative Docker installation..."
        curl -fsSL https://get.docker.com | sh
    fi
    
    echo "Starting and enabling Docker service..."
    sudo systemctl unmask docker.service docker.socket
    sudo systemctl start docker
    sudo systemctl enable docker
else
    echo -e "Docker is already installed."
fi

echo -e "Installing K3d..."
if ! command -v k3d &> /dev/null; then
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo -e "K3d is already installed"
fi

echo -e "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    mkdir -p ~/.kube

else
    echo -e "kubectl is already installed."
fi

echo -e "Installing Helm..."
if ! command -v helm &> /dev/null; then
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    helm repo add stable https://charts.helm.sh/stable
    helm repo update
else
    echo -e "Helm is already installed."
fi

echo "Adding GitLab Helm repository..."
helm repo add gitlab https://charts.gitlab.io/
helm repo update

echo -e "Setup completed successfully!"
