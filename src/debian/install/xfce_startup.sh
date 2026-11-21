#!/usr/bin/env bash
set -e

echo -e "\n------------------ starting Fcitx5 in the Xfce session ------------------"

xset -dpms &
xset s noblank &
xset s off &

session_pid=""
for _ in {1..10}; do
    session_pid=$(pgrep -u "$(id -u)" -x xfce4-session | head -n 1 || true)
    if [[ -n $session_pid ]]; then
        break
    fi
    sleep 1
done

if [[ -z $session_pid ]]; then
    echo "Xfce session did not start; cannot attach Fcitx5." >&2
    exit 1
fi

session_bus=$(tr '\0' '\n' < "/proc/$session_pid/environ" \
    | sed -n 's/^DBUS_SESSION_BUS_ADDRESS=//p')
if [[ -z $session_bus ]]; then
    echo "Xfce session has no D-Bus address; cannot start Fcitx5." >&2
    exit 1
fi

export DBUS_SESSION_BUS_ADDRESS="$session_bus"

if ! fcitx5-remote -a >/dev/null 2>&1; then
    fcitx5 -d
fi

for _ in {1..10}; do
    if fcitx5-remote -a >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

if ! fcitx5-remote -a >/dev/null 2>&1; then
    echo "Fcitx5 did not connect to the Xfce D-Bus session." >&2
    exit 1
fi

fcitx5-remote -s pinyin
echo "Fcitx5 Pinyin is ready in the active Xfce session."
