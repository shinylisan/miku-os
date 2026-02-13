#!/bin/bash
set -e # Exit if a command fails (except for the ones we 'allow' to fail)

echo "Starting MikuOS icon takeover..."

# Paths to our Miku files
MIKU_PNG="/usr/share/icons/hicolor/48x48/apps/start-here.png"
MIKU_SVG="/usr/share/icons/hicolor/scalable/apps/start-here.svg"

# Force link the icons
# Using -v (verbose) so we can see what it's doing in the logs
find /usr/share/icons -name "fedora-logo-icon.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -name "fedora-logo-icon.svg" -exec ln -sfv $MIKU_SVG {} \;
find /usr/share/icons -name "distributor-logo.svg" -exec ln -sfv $MIKU_SVG {} \;

# Update caches
gtk-update-icon-cache /usr/share/icons/hicolor || true
gtk-update-icon-cache /usr/share/icons/breeze || true

echo "Icon takeover complete!"
