var backlightDeviceCmd = "BL=\"\"; for C in /sys/class/backlight/gmux_backlight /sys/class/backlight/apple_gmux /sys/class/backlight/amdgpu_bl* /sys/class/backlight/intel_backlight /sys/class/backlight/acpi_video*; do [ -e \"$C\" ] && { BL=\"${C##*/}\"; break; }; done; [ -n \"$BL\" ] || { for C in /sys/class/backlight/*; do [ -e \"$C\" ] && [ \"${C##*/}\" != \"appletb_backlight\" ] && { BL=\"${C##*/}\"; break; }; done; }; [ -n \"$BL\" ] || exit 0; "
var backlightDetectCmd = backlightDeviceCmd + "echo \"$BL\""
var brightnessPercentCmd = backlightDeviceCmd + "brightnessctl -d \"$BL\" -m 2>/dev/null | cut -d\x27,\x27 -f4 | tr -d \x27%\x27 | awk \x27{print int($1)}\x27"

function brightnessSetCmd(step) {
    return (
        backlightDeviceCmd +
        "brightnessctl -d \"$BL\" set " + step + " >/dev/null 2>&1; " +
        "brightnessctl -d appletb_backlight set 100% >/dev/null 2>&1 || true; " +
        "PCT=$(brightnessctl -d \"$BL\" -m 2>/dev/null | cut -d\x27,\x27 -f4 | tr -d \x27%\x27 | awk \x27{print int($1)}\x27); " +
        "qs -c shell ipc call brightness set \"$PCT\" >/dev/null 2>&1 || true"
    )
}

function setBrightness(pct) {
    return brightnessSetCmd(Math.max(1, Math.min(100, Math.round(pct))) + "%")
}
