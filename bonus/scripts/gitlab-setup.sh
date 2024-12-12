#!/bin/bash
set -e

# Variables
GITLAB_URL="http://gitlab.local"

sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates postfix

echo "Configuring Postfix..."
sudo debconf-set-selections <<< "postfix postfix/mailname string gitlab.local"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

echo "Downloading GitLab Omnibus package..."
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

echo "Installing GitLab..."
sudo EXTERNAL_URL="$GITLAB_URL" apt-get install -y gitlab-ee
sudo gitlab-ctl status

# ---

sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# Install Docker
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
sudo docker --version

# Install k3s/k3d
curl -sfL https://get.k3s.io | sh -
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d cluster create dev
export KUBECONFIG=$(k3d kubeconfig write dev)
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sudo kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd
sudo kubectl create namespace dev
sudo kubectl apply -n dev -f ../confs/deployment.yaml
sudo kubectl get all -n dev
echo "Setup completed!"