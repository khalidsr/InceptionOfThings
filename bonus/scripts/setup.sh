#!/bin/bash
set -e

# Variables
GITLAB_URL="http://gitlab.local"

echo "Starting environment setup..."

# Step 1: Update system and install dependencies
echo "Updating system and installing required dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates postfix gnupg lsb-release apt-transport-https
# Step 2: Configure Postfix for email notifications
echo "Configuring Postfix for email notifications..."
sudo debconf-set-selections <<< "postfix postfix/mailname string gitlab.local"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo systemctl restart postfix
echo "Postfix configured successfully."

# Step 3: Install GitLab
echo "Adding GitLab Omnibus package repository..."
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
echo "Installing GitLab Community Edition..."
sudo EXTERNAL_URL="$GITLAB_URL" apt-get install -y gitlab-ee
sudo gitlab-ctl reconfigure
echo "GitLab installed and configured at $GITLAB_URL."

# Step 4: Install Docker
echo "Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl start docker
echo "Docker installed successfully. Version:"
sudo docker --version

# Step 5: Install Kubernetes (K3d) and K3s
echo "Installing Kubernetes tools: K3d and K3s..."
curl -sfL https://get.k3s.io | sh -
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
echo "Creating a Kubernetes cluster with K3d..."
sudo k3d cluster create dev
export KUBECONFIG=$(k3d kubeconfig write dev)
echo "K3d cluster created successfully."

echo "Environment setup completed successfully!"
