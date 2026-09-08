#!/usr/bin/env bash
# Robust launcher for Antigravity on Niri / Wayland / Hyprland

ANTIGRAVITY_BIN=""
if [ -x "/usr/bin/antigravity" ]; then
    ANTIGRAVITY_BIN="/usr/bin/antigravity"
elif [ -x "/opt/Antigravity/antigravity" ]; then
    ANTIGRAVITY_BIN="/opt/Antigravity/antigravity"
elif command -v antigravity >/dev/null 2>&1; then
    ANTIGRAVITY_BIN="$(command -v antigravity)"
fi

if [ -z "$ANTIGRAVITY_BIN" ]; then
    notify-send "Antigravity" "Executable not found" -u critical 2>/dev/null || true
    exit 1
fi

# Check if running under Niri and check window status
if command -v niri >/dev/null 2>&1 && [ -n "${NIRI_SOCKET:-}" ]; then
    has_win=$(niri msg --json windows 2>/dev/null | jq -r '[.[] | select(.app_id != null and (.app_id | test("antigravity"; "i")))] | length' 2>/dev/null || echo "0")
    if [ "$has_win" = "0" ] || [ -z "$has_win" ]; then
        # Clean stale headless/zombie process if any
        if pgrep -f "/opt/Antigravity/antigravity" >/dev/null 2>&1; then
            pkill -15 -f "/opt/Antigravity/antigravity" 2>/dev/null || true
            sleep 0.1
        fi
    fi
fi

exec "$ANTIGRAVITY_BIN" --ozone-platform-hint=auto "$@"
