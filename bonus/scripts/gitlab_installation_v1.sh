#!/bin/bash

# Variables
GITLAB_URL="http://gitlab.local"

# Update and install necessary packages
sudo apt-get update -y
sudo apt-get install -y curl openssh-server ca-certificates postfix

# Configure Postfix
echo "Configuring Postfix..."
sudo debconf-set-selections <<< "postfix postfix/mailname string gitlab.local"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

# Download and install GitLab Omnibus package
echo "Downloading GitLab Omnibus package..."
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

echo "Installing GitLab..."
sudo EXTERNAL_URL="$GITLAB_URL" apt-get install -y gitlab-ee

# Reconfigure GitLab to apply settings
sudo gitlab-ctl reconfigure

# Check GitLab status
sudo gitlab-ctl status

# Additional packages (if needed)
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

# Add gitlab.local to /etc/hosts if not already present
if ! grep -q "gitlab.local" /etc/hosts; then
    echo "127.0.0.1 gitlab.local" | sudo tee -a /etc/hosts
fi

echo "GitLab installation and configuration complete. Access it at $GITLAB_URL"
