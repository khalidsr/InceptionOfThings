#!/bin/bash

set -e

echo "Starting GitLab local installation..."

# Update and install dependencies
echo "Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Install Postfix for email notifications (optional but recommended)
echo "Installing Postfix (for email notifications)..."
sudo apt-get install -y postfix
sudo systemctl enable postfix
sudo systemctl start postfix

# Add the GitLab package repository
echo "Adding GitLab package repository..."
curl -fsSL https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

# Install GitLab Community Edition
echo "Installing GitLab Community Edition..."
sudo apt-get install -y gitlab-ce

# Configure GitLab
echo "Configuring GitLab..."
sudo gitlab-ctl reconfigure

# Start GitLab services
echo "Starting GitLab services..."
sudo gitlab-ctl start

# Check GitLab status
echo "Checking GitLab status..."
sudo gitlab-ctl status

# Output GitLab access details
echo "GitLab installation completed successfully!"
echo "You can now access GitLab at: http://<your-server-ip> (or http://localhost if installed locally)."
echo "Default username: root"
echo "To retrieve the default root password, check: /etc/gitlab/initial_root_password"