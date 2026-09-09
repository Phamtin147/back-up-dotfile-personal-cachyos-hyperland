#!/usr/bin/env bash
# ==============================================================================
# Script Full Backup toàn bộ cấu hình CachyOS / Arch Linux (Hyprland + Ryoku)
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "==> Bắt đầu sao lưu toàn bộ cấu hình máy vào: $DOTFILES_DIR"

# 1. Dọn dẹp thư mục tạm / cache cũ
rm -rf "$DOTFILES_DIR/.config"
rm -f "$DOTFILES_DIR/config/antigravity-css-preload.js\""

# 2. Xuất danh sách phần mềm (Packages)
echo "==> [1/9] Xuất danh sách gói phần mềm..."
mkdir -p "$DOTFILES_DIR/system/packages"
if command -v pacman >/dev/null 2>&1; then
    pacman -Qqen > "$DOTFILES_DIR/system/packages/pacman-explicit.txt" 2>/dev/null || true
    pacman -Qqem > "$DOTFILES_DIR/system/packages/pacman-aur.txt" 2>/dev/null || true
fi
if command -v flatpak >/dev/null 2>&1; then
    flatpak list --app --columns=application > "$DOTFILES_DIR/system/packages/flatpak.txt" 2>/dev/null || true
fi

# 3. Xuất dconf / GSettings
echo "==> [2/9] Xuất thiết lập hệ thống dconf..."
mkdir -p "$DOTFILES_DIR/system/dconf"
if command -v dconf >/dev/null 2>&1; then
    dconf dump / > "$DOTFILES_DIR/system/dconf/dconf-settings.ini" 2>/dev/null || true
fi

# 4. Sao lưu Dotfiles trong $HOME
echo "==> [3/9] Sao lưu dotfiles trong $HOME..."
mkdir -p "$DOTFILES_DIR/home"
for file in .zshrc .p10k.zsh .zprofile .bashrc .bash_profile .gitconfig .npmrc .Xresources cachyos-config.zsh; do
    if [ -f "$HOME/$file" ]; then
        if [ -L "$HOME/$file" ] && [ "$(readlink -f "$HOME/$file" 2>/dev/null || true)" = "$(readlink -f "$DOTFILES_DIR/home/$file" 2>/dev/null || true)" ]; then
            continue
        fi
        cp -af "$HOME/$file" "$DOTFILES_DIR/home/"
    fi
done

# 5. Sao lưu ~/.config (Ryoku, Hyprland, Quickshell, Fuzzel, Ghostty, Kitty, Fish, v.v.)
echo "==> [4/9] Sao lưu cấu hình ~/.config..."
mkdir -p "$DOTFILES_DIR/config"

CONFIG_ITEMS=(
    "ryoku"
    "hypr"
    "quickshell"
    "quickshell_symlinks"
    "fuzzel"
    "fastfetch"
    "matugen"
    "spicetify"
    "swappy"
    "qylock"
    "tmux"
    "zathura"
    "ghostty"
    "kitty"
    "alacritty"
    "btop"
    "yazi"
    "fish"
    "nvim"
    "cava"
    "gtk-3.0"
    "gtk-4.0"
    "qt5ct"
    "qt6ct"
    "QtProject"
    "xsettingsd"
    "fcitx"
    "fcitx5"
    "fontconfig"
    "nwg-look"
    "qBittorrent"
    "obs-studio"
    "Vial"
    "autostart"
    "systemd"
    "weylus"
    "baloofileinformationrc"
    "dolphinrc"
    "filetypesrc"
    "kiorc"
    "mimeapps.list"
    "pavucontrol.ini"
    "user-dirs.dirs"
    "user-dirs.locale"
    "chromium-flags.conf"
    "code-flags.conf"
    "starship.toml"
    "micro"
    "OpenRGB"
    "QDirStat"
    "vesktop"
    "voxtype"
    "zed"
    "xdg-desktop-portal"
)

for item in "${CONFIG_ITEMS[@]}"; do
    if [ -e "$HOME/.config/$item" ]; then
        if [ -L "$HOME/.config/$item" ] && [ "$(readlink -f "$HOME/.config/$item" 2>/dev/null || true)" = "$(readlink -f "$DOTFILES_DIR/config/$item" 2>/dev/null || true)" ]; then
            continue
        fi
        rm -rf "$DOTFILES_DIR/config/$item"
        cp -afr "$HOME/.config/$item" "$DOTFILES_DIR/config/"
    fi
done

# Sao lưu settings VSCode / Antigravity IDE (chỉ file cấu hình, không sao lưu cache/runtime)
mkdir -p "$DOTFILES_DIR/config/vscode"
if [ -f "$HOME/.config/Code/User/settings.json" ]; then
    cp -af "$HOME/.config/Code/User/settings.json" "$DOTFILES_DIR/config/vscode/settings.json"
fi
if [ -f "$HOME/.config/Code/User/keybindings.json" ]; then
    cp -af "$HOME/.config/Code/User/keybindings.json" "$DOTFILES_DIR/config/vscode/keybindings.json"
fi

# Sao lưu CSS tùy biến
if [ -f "$HOME/vscode-custom.css" ]; then
    cp -af "$HOME/vscode-custom.css" "$DOTFILES_DIR/vscode-custom.css"
elif [ -f "$HOME/.config/vscode-custom.css" ]; then
    cp -af "$HOME/.config/vscode-custom.css" "$DOTFILES_DIR/vscode-custom.css"
fi

# 6. Sao lưu Scripts ~/.local/bin
echo "==> [5/9] Sao lưu các scripts trong ~/.local/bin..."
mkdir -p "$DOTFILES_DIR/scripts"

for s in "$HOME/.local/bin"/*; do
    [ -f "$s" ] || continue
    name="$(basename "$s")"
    case "$name" in
        *.bak|*.pyc|__pycache__) continue ;;
    esac
    if [ -L "$s" ] && [[ "$(readlink -f "$s" 2>/dev/null || true)" == "$DOTFILES_DIR"* ]]; then
        continue
    fi
    cp -af "$s" "$DOTFILES_DIR/scripts/"
done

# 7. Sao lưu Fonts, Icons, Themes, Wallpapers, Desktop files, Shaders
echo "==> [6/9] Sao lưu Fonts, Icons, Themes, Wallpapers, Desktop files, Shaders..."
mkdir -p "$DOTFILES_DIR/fonts" "$DOTFILES_DIR/icons" "$DOTFILES_DIR/themes" "$DOTFILES_DIR/desktop" "$DOTFILES_DIR/wallpapers" "$DOTFILES_DIR/shaders"

# Fonts
if [ -d "$HOME/.local/share/fonts" ]; then
    rsync -a --delete "$HOME/.local/share/fonts/" "$DOTFILES_DIR/fonts/"
fi

# Icons & Cursors
if [ -d "$HOME/.icons" ]; then
    rsync -a --delete "$HOME/.icons/" "$DOTFILES_DIR/icons/"
fi

# Themes
if [ -d "$HOME/.themes" ]; then
    rsync -a --delete "$HOME/.themes/" "$DOTFILES_DIR/themes/"
fi

# Desktop entries
if [ -d "$HOME/.local/share/applications" ]; then
    rsync -a "$HOME/.local/share/applications/" "$DOTFILES_DIR/desktop/"
fi

# Shaders
if [ -d "$HOME/shaders" ]; then
    rsync -a --delete "$HOME/shaders/" "$DOTFILES_DIR/shaders/"
fi

# Wallpapers
if [ -d "$HOME/Pictures/Wallpapers" ]; then
    echo "    Đang sao lưu kho hình nền..."
    rsync -a --delete "$HOME/Pictures/Wallpapers/" "$DOTFILES_DIR/wallpapers/"
fi

# 8. Sao lưu cấu hình Ly Display Manager (/etc/ly) nếu có
echo "==> [7/9] Sao lưu cấu hình Ly Display Manager (/etc/ly)..."
mkdir -p "$DOTFILES_DIR/system/etc/ly"
if [ -d "/etc/ly" ]; then
    cp -afr /etc/ly/* "$DOTFILES_DIR/system/etc/ly/" 2>/dev/null || true
fi

# 9. Dọn dẹp các thư mục .git lồng nhau, caches và temp files
echo "==> [8/9] Dọn dẹp git và caches..."
find "$DOTFILES_DIR" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
find "$DOTFILES_DIR/icons" "$DOTFILES_DIR/themes" "$DOTFILES_DIR/config" -name ".git" -type d -prune -exec rm -rf {} + 2>/dev/null || true
rm -rf "$DOTFILES_DIR/config/Antigravity/Cache" "$DOTFILES_DIR/config/Antigravity/Code Cache" "$DOTFILES_DIR/config/Antigravity/GPUCache" "$DOTFILES_DIR/config/Antigravity/blob_storage" 2>/dev/null || true

# 10. Phân quyền thực thi
echo "==> [9/9] Phân quyền thực thi cho scripts..."
find "$DOTFILES_DIR/scripts" -type f -exec chmod +x {} + 2>/dev/null || true
chmod +x "$DOTFILES_DIR/install.sh" "$DOTFILES_DIR/backup.sh" 2>/dev/null || true

echo "==> HOÀN TẤT FULL BACKUP 100%!"
