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

# Remove kube folder that contains kubectl configuration
sudo rm -rf ~/.kube

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

# Uninstall kubectl
echo "Removing kubectl..."
sudo apt-get remove -y kubectl

# Uninstall Kubeadm, Kubelet, Kubectl, and Kubernetes-cni
echo "Removing Kubernetes components (kubeadm, kubelet, kubectl, kubernetes-cni)..."
sudo apt-get remove -y kubeadm kubelet kubectl kubernetes-cni

# Remove any remaining dependencies
echo "Cleaning up unused dependencies..."
sudo apt-get autoremove -y

# Remove Kubernetes configurations and directories
echo "Removing Kubernetes directories and configurations..."
sudo rm -rf ~/.kube
sudo rm -rf /etc/kubernetes
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/kubeadm
sudo rm -rf /var/lib/cni
sudo rm -rf /run/kubernetes
sudo rm -rf /usr/local/bin/kube*

# Remove K3d clusters (if using K3d)
if command -v k3d &> /dev/null; then
    echo "Removing K3d clusters and K3d..."
    k3d cluster delete --all
    sudo rm -rf ~/.k3d
    sudo rm /usr/local/bin/k3d
fi

# Remove any Docker containers or volumes related to Kubernetes
echo "Removing Docker containers and volumes related to Kubernetes..."
docker rm -f $(docker ps -a -q --filter ancestor=k8s.gcr.io) 2>/dev/null
docker volume prune -f
docker network prune -f

# Clean up apt cache
echo "Cleaning up package cache..."
sudo apt-get clean

echo "Kubernetes and related components have been removed."


# Cleanup unused packages and disk space
echo_info "Performing system cleanup..."
sudo apt-get autoremove -y
sudo apt-get autoclean
echo_success "System cleanup completed."

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
