#!/usr/bin/env bash
set -e

desktop_dir="$HOME/Desktop"
mkdir -p "$desktop_dir"
rm -f "$desktop_dir/firefox.desktop" "$desktop_dir/chromium-browser.desktop"

cat > "$desktop_dir/google-chrome.desktop" <<'EOF'
[Desktop Entry]
Version=1.0
Name=Google Chrome
Comment=Browse the web
Exec=/usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage --disable-gpu --no-first-run --no-default-browser-check --start-maximized %U
Terminal=false
Type=Application
Icon=google-chrome
Categories=Network;WebBrowser;
StartupNotify=true
EOF

chmod 0755 "$desktop_dir/google-chrome.desktop"
