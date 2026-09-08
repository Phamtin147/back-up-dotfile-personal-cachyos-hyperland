-- --- hypr/user.lua --------------------------------------------------------
-- Custom Hyprland & Ryoku configuration for MacBook Pro 16,1

local mod = "SUPER"

-- 1. Scrolling Layout (Strict Niri-style column sizing)
hl.config({
    general = {
        layout = "scrolling",
        no_focus_fallback = false,
    },
    input = {
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            drag_lock = true,
            disable_while_typing = false,
        },
    },
    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
    },
    scrolling = {
        column_width = 1.0,
        explicit_column_widths = "0.5, 1.0",
        focus_fit_method = 1,
        follow_focus = true,
        wrap_focus = false,
        wrap_swapcol = false,
    },
})

-- 2. Keep workspace animation vertical (slidevert)
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })

-- 3. Touch Bar & Hardware Shortcuts
hl.bind(mod .. " + F1", hl.dsp.exec_cmd("niri-brightness down"), { allow_when_locked = true })
hl.bind(mod .. " + F2", hl.dsp.exec_cmd("niri-brightness up"), { allow_when_locked = true })
hl.bind(mod .. " + F5", hl.dsp.exec_cmd("brightnessctl -d :white:kbd_backlight set 10%-"), { allow_when_locked = true })
hl.bind(mod .. " + F6", hl.dsp.exec_cmd("brightnessctl -d :white:kbd_backlight set +10%"), { allow_when_locked = true })

-- Touch Bar 100% brightness & Polkit & Fcitx5 Autostart
hl.exec_cmd("brightnessctl -d appletb_backlight set 100%")
hl.exec_cmd("fcitx5 -d --replace")
hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

-- Swappy Screenshot Editor UI Rule
hl.window_rule({ name = "float-swappy", match = { class = "swappy" }, float = true, center = true })
