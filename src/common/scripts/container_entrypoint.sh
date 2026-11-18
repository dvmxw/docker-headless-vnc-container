#!/usr/bin/env bash
set -e

if [[ ${SYSTEMD:-false} == true ]]; then
    if [[ $(id -u) -ne 0 ]]; then
        echo "SYSTEMD=true requires the container to run as root (for example, with --user 0)." >&2
        exit 1
    fi

    python3 - <<'PY'
import os
import re

with open("/run/container-environment", "w", encoding="utf-8") as environment_file:
    for key, value in os.environ.items():
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", key):
            continue
        escaped = (
            value.replace("\\", "\\\\")
            .replace('"', '\\"')
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t")
        )
        environment_file.write(f'{key}="{escaped}"\n')
PY
    chmod 0644 /run/container-environment
    exec /sbin/init
fi

/dockerstartup/vnc_startup.sh "$@" &
child_pid=$!

shutdown() {
    kill -TERM "$child_pid" 2>/dev/null || true
    wait "$child_pid" 2>/dev/null || true
    exit 0
}
trap shutdown SIGTERM SIGINT SIGRTMIN+3

if wait "$child_pid"; then
    exit 0
else
    exit $?
fi
