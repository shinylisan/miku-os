#!/bin/bash
set -e

echo "=== Starting MikuOS Aesthetic Takeover ==="

# --- 1. UNPACK CUSTOM ICONS ---
if [ -f "/usr/share/icons/Cyan-Breeze-Dark-Icons.tar.xz" ]; then
    echo "Extracting Cyan-Breeze-Dark-Icons..."
    tar -xf /usr/share/icons/Cyan-Breeze-Dark-Icons.tar.xz -C /usr/share/icons/
    rm /usr/share/icons/Cyan-Breeze-Dark-Icons.tar.xz
else
    echo "WARNING: Icon archive not found. Skipping extraction."
fi

# --- 2. ICON VARIABLES ---
MIKU_PNG="/usr/share/icons/hicolor/48x48/apps/start-here.png"
MIKU_SVG="/usr/share/icons/hicolor/scalable/apps/start-here.svg"
TARGET_THEME="/usr/share/icons/Cyan-Breeze-Dark-Icons"

# --- 3. TARGETED FIX FOR NEW THEME (THE FIX IS HERE) ---
if [ -d "$TARGET_THEME" ]; then
    echo "Injecting Miku Logo into Cyan-Breeze..."
    
    # Ensure the target directories exist
    mkdir -p $TARGET_THEME/places/16/
    mkdir -p $TARGET_THEME/places/22/
    mkdir -p $TARGET_THEME/places/scalable/
    
    # OVERWRITE the exact -symbolic files KDE actually looks for!
    cp -f $MIKU_SVG $TARGET_THEME/places/16/start-here-kde-symbolic.svg
    cp -f $MIKU_SVG $TARGET_THEME/places/22/start-here-kde-symbolic.svg
    cp -f $MIKU_SVG $TARGET_THEME/places/scalable/start-here-kde-symbolic.svg
    
    # Also overwrite the standard names just to be absolutely bulletproof
    cp -f $MIKU_SVG $TARGET_THEME/places/16/start-here-kde.svg
    cp -f $MIKU_SVG $TARGET_THEME/places/22/start-here-kde.svg
    cp -f $MIKU_SVG $TARGET_THEME/places/scalable/start-here-kde.svg
    
    # Update the icon cache so Plasma notices the replaced files
    gtk-update-icon-cache -f $TARGET_THEME || true
fi

# --- 4. EXISTING SHOTGUN LOGIC ---
echo "Redirecting all generic 'places' to Miku..."
find /usr/share/icons -path "*/places/*" -name "start-here.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -path "*/places/*" -name "start-here.svg" -exec ln -sfv $MIKU_SVG {} \;

find /usr/share/icons -name "fedora-logo-icon.png" -exec ln -sfv $MIKU_PNG {} \;
find /usr/share/icons -name "fedora-logo-icon.svg" -exec ln -sfv $MIKU_SVG {} \;

if [ -d "/usr/share/fedora-logos" ]; then
    echo "Sanitizing fedora-logos folder..."
    find /usr/share/fedora-logos -name "*logo*" -exec ln -sfv $MIKU_SVG {} \;
fi

# --- 5. WALLPAPER LOGIC ---
echo "Redirecting Default Wallpapers..."
MIKU_MASTER="/usr/share/wallpapers/MikuOS/contents/images/1920x1080.png"

mkdir -p /usr/share/wallpapers/Next/contents/images/
ln -sfv $MIKU_MASTER /usr/share/wallpapers/Next/contents/images/base.png
ln -sfv $MIKU_MASTER /usr/share/wallpapers/Next/contents/images/1920x1080.png

mkdir -p /usr/share/backgrounds
ln -sfv $MIKU_MASTER /usr/share/backgrounds/default.jxl
ln -sfv $MIKU_MASTER /usr/share/backgrounds/default-dark.jxl

FEDORA_BG_DIR="/usr/share/backgrounds/fedora-workstation"
mkdir -p $FEDORA_BG_DIR
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default.jxl
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default-dark.jxl
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default.png
ln -sfv $MIKU_MASTER $FEDORA_BG_DIR/default-dark.png

# --- 6. THE IDENTITY SWAP ---
if [ -d "/usr/share/icons/Cyan-Breeze-Dark-Icons" ]; then
    echo "Performing the Cyan-Breeze Identity Swap..."
    mv /usr/share/icons/breeze /usr/share/icons/breeze-original || true
    ln -sf /usr/share/icons/Cyan-Breeze-Dark-Icons /usr/share/icons/breeze
fi

echo "=== MikuOS Takeover Complete ==="
chmod -R 644 /usr/share/fonts/Comfortaa
fc-cache -fv
