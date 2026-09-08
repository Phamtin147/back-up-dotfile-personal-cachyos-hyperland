#!/usr/bin/env bash
# Sync Matugen generated colors into all Zen Browser profiles
set -euo pipefail

GEN_DIR="$HOME/.cache/noctalia/zen-browser"
mkdir -p "$GEN_DIR"

CSS_CHROME="$GEN_DIR/zen-userChrome.css"
CSS_CONTENT="$GEN_DIR/zen-userContent.css"

LINE_CHROME="@import \"$CSS_CHROME\";"
LINE_CONTENT="@import \"$CSS_CONTENT\";"

ZEN_DIRS=()
if [ -d "$HOME/.config/zen" ]; then
    ZEN_DIRS+=("$HOME/.config/zen")
fi
if [ -d "$HOME/.zen" ]; then
    ZEN_DIRS+=("$HOME/.zen")
fi

if [ ${#ZEN_DIRS[@]} -eq 0 ]; then
    exit 0
fi

for zdir in "${ZEN_DIRS[@]}"; do
    for pdir in "$zdir"/*; do
        if [ -d "$pdir" ] && { [ -f "$pdir/prefs.js" ] || [ -f "$pdir/compatibility.ini" ] || [ -d "$pdir/chrome" ]; }; then
            CHROME_DIR="$pdir/chrome"
            mkdir -p "$CHROME_DIR"
            
            U_CHROME="$CHROME_DIR/userChrome.css"
            U_CONTENT="$CHROME_DIR/userContent.css"
            
            touch "$U_CHROME" "$U_CONTENT"
            
            # Clean old imports
            sed -i '/zen-userChrome\.css/d' "$U_CHROME" 2>/dev/null || true
            sed -i '/zen-userContent\.css/d' "$U_CONTENT" 2>/dev/null || true
            
            # Prepend import so user customization can override if needed
            echo -e "$LINE_CHROME\n$(cat "$U_CHROME")" > "$U_CHROME"
            echo -e "$LINE_CONTENT\n$(cat "$U_CONTENT")" > "$U_CONTENT"
            
            # Ensure stylesheet customization is enabled in prefs.js
            PREFS="$pdir/prefs.js"
            if [ -f "$PREFS" ]; then
                if ! grep -q 'toolkit.legacyUserProfileCustomizations.stylesheets' "$PREFS"; then
                    echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$PREFS"
                fi
            fi
        fi
    done
done
