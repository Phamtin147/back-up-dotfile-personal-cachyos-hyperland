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
        follow_mouse = 0,
        mouse_refocus = false,
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

-- 2. Vertical workspace animation (slidevert like Niri)
hl.curve("smoothEase", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "smoothEase", style = "slidevert" })

-- 3. Smooth Rendering & Optimized Blur (Ultra silky 60fps)
hl.config({
    decoration = {
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            new_optimizations = true,
            xray = true,
        },
        shadow = {
            enabled = false,
        },
    },
    misc = {
        vrr = 1,
        animate_manual_resizes = false,
    }
})

-- 3. Touchpad Gestures (Niri-style column scrolling & vertical workspaces)
hl.gesture({
    fingers = 3,
    direction = "left",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-col-nav right")
        end
    }
})
hl.gesture({
    fingers = 3,
    direction = "right",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-col-nav left")
        end
    }
})
hl.gesture({
    fingers = 3,
    direction = "up",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-ws-niri focus down")
        end
    }
})
hl.gesture({
    fingers = 3,
    direction = "down",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-ws-niri focus up")
        end
    }
})

hl.gesture({
    fingers = 4,
    direction = "left",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-col-nav right")
        end
    }
})
hl.gesture({
    fingers = 4,
    direction = "right",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-col-nav left")
        end
    }
})
hl.gesture({
    fingers = 4,
    direction = "up",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-ws-niri focus down")
        end
    }
})
hl.gesture({
    fingers = 4,
    direction = "down",
    action = {
        finish = function()
            hl.exec_cmd("~/.local/bin/ryoku-ws-niri focus up")
        end
    }
})



-- 3. Touch Bar & Hardware Shortcuts
hl.bind(mod .. " + F1", hl.dsp.exec_cmd("niri-brightness down"), { allow_when_locked = true })
hl.bind(mod .. " + F2", hl.dsp.exec_cmd("niri-brightness up"), { allow_when_locked = true })
hl.bind(mod .. " + F5", hl.dsp.exec_cmd("brightnessctl -d :white:kbd_backlight set 10%-"), { allow_when_locked = true })
hl.bind(mod .. " + F6", hl.dsp.exec_cmd("brightnessctl -d :white:kbd_backlight set +10%"), { allow_when_locked = true })

-- Session / Power Menu (Super + Shift + Q)
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("ryoku-session-menu"))

-- Touch Bar 100% brightness & Polkit & Fcitx5 Autostart
hl.exec_cmd("brightnessctl -d appletb_backlight set 100%")
hl.exec_cmd("fcitx5 -d --replace")
hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

-- Swappy Screenshot Editor UI Rule
hl.window_rule({ name = "float-swappy", match = { class = "swappy" }, float = true, center = true })
