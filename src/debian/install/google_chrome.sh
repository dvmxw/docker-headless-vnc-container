#!/usr/bin/env bash
set -e

if [[ $(dpkg --print-architecture) != amd64 ]]; then
    echo "Google Chrome is only available for amd64 Linux." >&2
    exit 1
fi

echo "Install Google Chrome Stable"
apt-get update
apt-get install -y ca-certificates gnupg wget

install -d -m 0755 /etc/apt/keyrings
wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
chmod a+r /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list

apt-get update
apt-get install -y google-chrome-stable
apt-get clean
rm -rf /var/lib/apt/lists/*
