#!/bin/bash
# 1. Define our Master Miku Files
MIKU_PNG="/usr/share/icons/hicolor/48x48/apps/start-here.png"
MIKU_SVG="/usr/share/icons/hicolor/scalable/apps/start-here.svg"

echo "Applying MikuOS Icon Fixes..."

# 2. Symlinking to bypass duplicates
find /usr/share/icons -name "fedora-logo-icon.png" -exec ln -sf $MIKU_PNG {} \;
find /usr/share/icons -name "fedora-logo-icon.svg" -exec ln -sf $MIKU_SVG {} \;
find /usr/share/icons -name "distributor-logo.svg" -exec ln -sf $MIKU_SVG {} \;

# 3. Refresh Cache
gtk-update-icon-cache /usr/share/icons/hicolor || true
gtk-update-icon-cache /usr/share/icons/breeze || true
