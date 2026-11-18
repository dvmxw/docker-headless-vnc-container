#!/usr/bin/env bash
set -e

echo "Create the default headless user with passwordless sudo"
apt-get update
apt-get install -y sudo

if ! getent group 1000 >/dev/null; then
    groupadd --gid 1000 headless
fi

if ! getent passwd headless >/dev/null; then
    if getent passwd 1000 >/dev/null; then
        echo "UID 1000 is already assigned to another user." >&2
        exit 1
    fi
    useradd --uid 1000 --gid 1000 --home-dir /headless \
        --no-create-home --shell /bin/bash headless
fi

if [[ $(id -u headless) != 1000 || $(id -g headless) != 1000 ]]; then
    echo "The headless account must use UID and GID 1000." >&2
    exit 1
fi

printf 'headless ALL=(ALL:ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/headless
chmod 0440 /etc/sudoers.d/headless
visudo -cf /etc/sudoers.d/headless

apt-get clean
rm -rf /var/lib/apt/lists/*
