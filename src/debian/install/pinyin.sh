#!/usr/bin/env bash
set -e

echo "Install Fcitx5 Chinese Pinyin input method"
apt-get update
apt-get install -y fcitx5 fcitx5-chinese-addons fcitx5-frontend-gtk3 fcitx5-frontend-qt5 dbus-x11
apt-get clean
rm -rf /var/lib/apt/lists/*
