#!/usr/bin/env bash
# Universal Wallpaper & Theme Setter for Hyprland / Niri / Ryoku / Noctalia
set -e
FILE="${1:-$HOME/Pictures/Wallpapers/YoRHa_Dark_4K.png}"

if [ -f "$FILE" ]; then
    # 1. Push to awww Wayland renderer
    awww img "$FILE" --transition-type wipe --transition-angle 30 2>/dev/null || awww img "$FILE" 2>/dev/null || true
    # 2. Push to Ryoku / Noctalia in-shell wallpaper
    ryoku-shell wallpaper set "$FILE" 2>/dev/null || true
    qs -c noctalia-shell ipc call wallpaper set "$FILE" 2>/dev/null || true
    # 3. Trigger Matugen dynamic palette sync for core and all apps
    matugen image "$FILE" -m dark --source-color-index 0 --config ~/.config/matugen/config.toml 2>/dev/null || true
    matugen image "$FILE" -m dark --source-color-index 0 --config ~/.config/matugen/apps.toml 2>/dev/null || true
    python3 ~/.local/bin/sync-plymouth-logo.py 2>/dev/null || true
fi
