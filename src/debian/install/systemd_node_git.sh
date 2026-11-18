#!/usr/bin/env bash
set -e

echo "Install systemd, Git, and current Node.js"
apt-get update
apt-get install -y ca-certificates gnupg

install -d -m 0755 /etc/apt/keyrings
wget -qO- https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
chmod a+r /etc/apt/keyrings/nodesource.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_current.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list

apt-get update
apt-get install -y git nodejs systemd systemd-sysv util-linux
apt-get clean
rm -rf /var/lib/apt/lists/*
