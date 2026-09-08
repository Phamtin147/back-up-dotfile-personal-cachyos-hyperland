#!/usr/bin/env bash
# Auto-sync Matugen/Wallpaper colors to ALL VS Code & Antigravity IDE themes & settings
set -euo pipefail

RENDERED_THEME="$HOME/.vscode/extensions/noctalia.noctaliatheme-0.0.5-universal/themes/NoctaliaTheme-color-theme.json"

if [ ! -f "$RENDERED_THEME" ]; then
    RENDERED_THEME="$HOME/.antigravity/extensions/noctalia.noctaliatheme-0.0.5-universal/themes/NoctaliaTheme-color-theme.json"
fi

if [ ! -f "$RENDERED_THEME" ]; then
    echo "Rendered theme not found."
    exit 0
fi

# 1. Copy the rendered real hex colors to all 4 extension theme files
THEME_FILES=(
    "$HOME/.vscode/extensions/noctalia.noctaliatheme-0.0.5-universal/themes/NoctaliaTheme-color-theme.json"
    "$HOME/.vscode/extensions/noctalia.noctaliatheme-0.0.5/themes/NoctaliaTheme-color-theme.json"
    "$HOME/.antigravity/extensions/noctalia.noctaliatheme-0.0.5-universal/themes/NoctaliaTheme-color-theme.json"
    "$HOME/.antigravity/extensions/noctalia.noctaliatheme-0.0.5/themes/NoctaliaTheme-color-theme.json"
)

for tf in "${THEME_FILES[@]}"; do
    if [ "$tf" != "$RENDERED_THEME" ] && [ -d "$(dirname "$tf")" ]; then
        cp -f "$RENDERED_THEME" "$tf"
        echo "Updated theme file: $tf"
    fi
done

TARGET_SETTINGS=(
    "$HOME/.config/Code/User/settings.json"
    "$HOME/.config/Code - OSS/User/settings.json"
    "$HOME/.config/Antigravity/User/settings.json"
    "$HOME/.config/Antigravity IDE/User/settings.json"
    "$HOME/.config/VSCodium/User/settings.json"
)

# 2. Sync to all target settings.json files with REAL HEX COLORS
python3 - "$RENDERED_THEME" "${TARGET_SETTINGS[@]}" << 'PYEOF'
import json, sys, os, re

theme_path = sys.argv[1]
targets = sys.argv[2:]

try:
    with open(theme_path, "r", encoding="utf-8") as f:
        theme = json.load(f)
except Exception as e:
    print(f"Error loading {theme_path}: {e}")
    sys.exit(0)

colors = theme.get("colors", {})
# Ensure tab borders are 100% transparent in settings.json
colors["tab.activeBorder"] = "#00000000"
colors["tab.activeBorderTop"] = "#00000000"
colors["tab.border"] = "#00000000"
colors["tab.unfocusedActiveBorder"] = "#00000000"
colors["tab.unfocusedActiveBorderTop"] = "#00000000"
colors["editorGroupHeader.tabsBorder"] = "#00000000"
colors["editorGroupHeader.border"] = "#00000000"

token_rules = []
for item in theme.get("tokenColors", []):
    scope = item.get("scope")
    fg = item.get("settings", {}).get("foreground")
    if scope and fg:
        token_rules.append({"scope": scope, "settings": {"foreground": fg}})

sem = theme.get("semanticTokenColors", {})

for target in targets:
    if not os.path.exists(target):
        pdir = os.path.dirname(target)
        if not os.path.exists(pdir):
            continue
        settings = {}
    else:
        try:
            with open(target, "r", encoding="utf-8") as f:
                raw = f.read()
                raw_clean = re.sub(r',(\s*[\}\]])', r'\1', raw)
                settings = json.loads(raw_clean)
        except Exception:
            settings = {}

    settings["workbench.colorTheme"] = "NoctaliaTheme"
    settings["workbench.colorCustomizations"] = colors
    settings["editor.tokenColorCustomizations"] = {"textMateRules": token_rules}
    if sem:
        settings["editor.semanticTokenColorCustomizations"] = {"rules": sem}

    try:
        os.makedirs(os.path.dirname(target), exist_ok=True)
        with open(target, "w", encoding="utf-8") as f:
            json.dump(settings, f, indent=4, ensure_ascii=False)
        print(f"Synced colors to: {target}")
    except Exception as e:
        print(f"Failed writing to {target}: {e}")

# 3. Update custom CSS variables for Antigravity / VS Code if present
custom_css_files = [
    os.path.expanduser("~/.config/vscode-custom-theme/css.css"),
    os.path.expanduser("~/vscode-custom.css")
]
primary_color = colors.get("activityBarBadge.background") or colors.get("button.background") or "#16B673"

for ccss in custom_css_files:
    if os.path.exists(ccss):
        try:
            with open(ccss, "r", encoding="utf-8") as f:
                content = f.read()
            content = re.sub(r'--accent-color:\s*[^;]+;', f'--accent-color: {primary_color};', content)
            with open(ccss, "w", encoding="utf-8") as f:
                f.write(content)
            print(f"Updated accent color ({primary_color}) in: {ccss}")
        except Exception as e:
            print(f"Failed updating {ccss}: {e}")

PYEOF
