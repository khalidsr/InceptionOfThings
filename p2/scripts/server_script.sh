#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
sudo apt-get install -y curl
curl -sfL https://get.k3s.io | sh -

echo "done"
