#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Installing fonts-wqy-zenhei"
apt-get update
apt-get install -y fonts-wqy-zenhei
apt-get clean -y
