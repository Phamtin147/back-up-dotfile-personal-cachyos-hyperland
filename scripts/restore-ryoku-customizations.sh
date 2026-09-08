#!/usr/bin/env bash
# Automatically reapplies all custom Ryoku patches after a system update
set -e
PATCH_DIR="$HOME/back-up-dotfile-personal-cachyos/custom-patches"

if [ -d "$PATCH_DIR" ]; then
    echo "Restoring custom Ryoku/Quickshell customizations..."
    echo "1" | sudo -S cp -rf "$PATCH_DIR/qsbar/modules/"* /usr/share/ryoku/config/quickshell/shell/modules/bar/barstyles/qsbar/modules/ 2>/dev/null || true
    echo "1" | sudo -S cp -f "$PATCH_DIR/qsbar/Theme.qml" /usr/share/ryoku/config/quickshell/shell/modules/bar/barstyles/qsbar/Theme.qml 2>/dev/null || true
    echo "1" | sudo -S cp -f "$PATCH_DIR/qsbar/BarSlot.qml" /usr/share/ryoku/config/quickshell/shell/modules/bar/barstyles/qsbar/BarSlot.qml 2>/dev/null || true
    echo "1" | sudo -S cp -f "$PATCH_DIR/qsbar/RyokuPower.js" /usr/share/ryoku/config/quickshell/shell/modules/bar/barstyles/qsbar/RyokuPower.js 2>/dev/null || true
    echo "1" | sudo -S cp -f "$PATCH_DIR/qsbar/services/OsdFeed.qml" /usr/share/ryoku/config/quickshell/shell/services/OsdFeed.qml 2>/dev/null || true
    echo "1" | sudo -S cp -rf "$PATCH_DIR/qsbar/ImageCarousel"*.qml /usr/share/ryoku/config/quickshell/shell/modules/bar/barstyles/qsbar/panels/ 2>/dev/null || true
    echo "1" | sudo -S cp -f "$PATCH_DIR/matugen-apps.toml" /usr/share/ryoku/config/matugen/apps.toml 2>/dev/null || true
    echo "1" | sudo -S cp -f "$PATCH_DIR/logo-xin.png" /usr/share/plymouth/themes/ryoku/logo.png 2>/dev/null || true
    systemctl --user restart ryoku-shell 2>/dev/null || true
    echo "Done! All customizations restored 100%."
fi
