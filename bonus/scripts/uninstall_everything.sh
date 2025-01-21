#!/bin/bash

# Function to display messages
echo_info() {
    echo -e "\e[34m[INFO]\e[0m $1"
}

echo_warn() {
    echo -e "\e[33m[WARN]\e[0m $1"
}

echo_success() {
    echo -e "\e[32m[SUCCESS]\e[0m $1"
}

# Uninstall k3d
echo_info "Uninstalling k3d..."
if [ -f /usr/local/bin/k3d ]; then
    sudo rm /usr/local/bin/k3d
    echo_success "k3d removed."
else
    echo_warn "k3d binary not found. Skipping..."
fi

# Uninstall k3s
echo_info "Uninstalling k3s..."
if [ -f /usr/local/bin/k3s-uninstall.sh ]; then
    sudo /usr/local/bin/k3s-uninstall.sh
    echo_success "k3s uninstalled."
else
    echo_warn "k3s uninstall script not found. Skipping..."
fi

# Remove k3s directories
echo_info "Cleaning up k3s directories..."
sudo rm -rf /etc/rancher /var/lib/rancher /var/lib/kubelet
echo_success "k3s directories cleaned up."

# Uninstall Docker
echo_info "Uninstalling Docker..."
sudo systemctl stop docker
sudo systemctl stop docker.socket
sudo apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce 
sudo apt-get purge -y docker-engine docker docker.io containerd runc
sudo rm -rf /var/lib/docker /etc/docker
sudo rm -rf /usr/local/bin/docker /usr/local/bin/docker-compose
sudo rm -rf /var/lib/docker /etc/docker
sudo rm -rf /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
echo_success "Docker uninstalled."

# Cleanup unused packages and disk space
echo_info "Performing system cleanup..."
sudo apt-get autoremove -y
sudo apt-get autoclean
echo_success "System cleanup completed."

# uninstall Helm
echo_info "Uninstalling Helm..."
sudo rm -rf $HOME/.cache/helm
sudo rm -rf $HOME/.config/helm
sudo rm -rf $HOME/.local/share/helm
echo_success "Helm Uninstalled."

# Verify if any processes are still running
echo_info "Checking for leftover processes..."
LEFTOVER_PROCESSES=$(ps aux | grep -E 'k3d|k3s|docker' | grep -v grep)
if [ -n "$LEFTOVER_PROCESSES" ]; then
    echo_warn "Found leftover processes:"
    echo "$LEFTOVER_PROCESSES"
    echo_warn "You may need to manually kill these processes."
else
    echo_success "No leftover processes found."
fi

sudo rm -rf /usr/bin/docker /usr/libexec/docker /usr/share/man/man1/docker.1.gz /usr/local/bin/kubectl /usr/share/keyrings/docker-archive-keyring.gpg 

echo_success "Uninstallation of k3d, k3s, and Docker completed."

echo "Starting environment cleanup and uninstallation..."

# Step 1: Stop and remove GitLab
echo "Stopping GitLab services..."
if command -v gitlab-ctl &> /dev/null; then
  sudo gitlab-ctl stop
  echo "Removing GitLab installation..."
  sudo apt-get remove --purge -y gitlab-ee
  sudo rm -rf /etc/gitlab /var/opt/gitlab /var/log/gitlab
  echo "GitLab uninstalled successfully."
else
  echo "GitLab not found. Skipping."
fi

# Step 2: Stop and remove Docker
echo "Stopping Docker services..."
if systemctl is-active --quiet docker; then
  sudo systemctl stop docker
  sudo apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo rm -rf /var/lib/docker /etc/docker
  sudo rm -rf /var/lib/containerd
  echo "Docker uninstalled successfully."
else
  echo "Docker not found or already stopped. Skipping."
fi

# Step 3: Remove K3d and Kubernetes resources
echo "Removing Kubernetes cluster and K3d..."
if command -v k3d &> /dev/null; then
  k3d cluster delete dev || echo "No K3d cluster found to delete."
  sudo rm -f $(which k3d)
  echo "K3d uninstalled successfully."
else
  echo "K3d not found. Skipping."
fi

echo "Removing K3s installation..."
if command -v k3s-uninstall.sh &> /dev/null; then
  sudo /usr/local/bin/k3s-uninstall.sh || echo "K3s uninstall script not found."
  echo "K3s uninstalled successfully."
else
  echo "K3s not found. Skipping."
fi

# Step 4: Remove Argo CD
echo "Removing Argo CD resources..."
if kubectl get namespaces | grep -q "argocd"; then
  sudo kubectl delete namespace argocd || echo "Failed to delete 'argocd' namespace."
else
  echo "Argo CD namespace not found. Skipping."
fi

# Step 5: Remove application resources
echo "Removing application resources from 'dev' namespace..."
if kubectl get namespaces | grep -q "dev"; then
  sudo kubectl delete namespace dev || echo "Failed to delete 'dev' namespace."
else
  echo "Application namespace 'dev' not found. Skipping."
fi

# Step 6: Clean up additional files and package repositories
echo "Cleaning up additional files and package repositories..."
sudo rm -rf /etc/apt/keyrings/docker.gpg
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/sources.list.d/gitlab_gitlab-ee.list
sudo apt-get autoremove -y
sudo apt-get clean

# Final step: Verify cleanup
echo "Verifying uninstallation..."
echo "Remaining GitLab files:"
sudo find /etc /var -name "*gitlab*" || echo "No GitLab files found."
echo "Remaining Docker files:"
sudo find /var /etc -name "*docker*" || echo "No Docker files found."
echo "Remaining Kubernetes files:"
sudo find /usr /var /etc -name "*k3d*" -o -name "*k3s*" || echo "No Kubernetes files found."

echo "Environment cleanup and uninstallation completed successfully!"