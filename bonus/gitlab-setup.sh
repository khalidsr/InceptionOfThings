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
