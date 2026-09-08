local mod = "SUPER"

local ok, rebinds = pcall(require, "rebinds")
if not ok or type(rebinds) ~= "table" then rebinds = {} end
local function K(k) return rebinds[k] or k end

-- =============================================================================
-- WINDOW & COLUMN CONTROLS (Niri layout & horizontal tape navigation)
-- =============================================================================
hl.bind(K(mod .. " + Q"),         hl.dsp.window.close())

-- Mod + F: Maximize Column (50% <-> 100%)
hl.bind(K(mod .. " + F"), hl.dsp.exec_cmd("~/.local/bin/ryoku-col-toggle"))

-- Mod + SHIFT + F: True Fullscreen
hl.bind(K(mod .. " + SHIFT + F"), hl.dsp.window.fullscreen(0))
hl.bind(K(mod .. " + T"),         hl.dsp.window.float({ action = "toggle" }))

-- Focus Columns Horizontally (Left / Right / H / L) - Niri style: stops at edge, never loses focus
hl.bind(K(mod .. " + Left"),      hl.dsp.exec_cmd("~/.local/bin/ryoku-col-nav left"))
hl.bind(K(mod .. " + H"),         hl.dsp.exec_cmd("~/.local/bin/ryoku-col-nav left"))
hl.bind(K(mod .. " + Right"),     hl.dsp.exec_cmd("~/.local/bin/ryoku-col-nav right"))
hl.bind(K(mod .. " + L"),         hl.dsp.exec_cmd("~/.local/bin/ryoku-col-nav right"))

-- Move / Swap Columns Horizontally (Ctrl + Left / Right / H / L)
hl.bind(K(mod .. " + CTRL + Left"),   hl.dsp.layout("swapcol l"))
hl.bind(K(mod .. " + CTRL + H"),      hl.dsp.layout("swapcol l"))
hl.bind(K(mod .. " + CTRL + Right"),  hl.dsp.layout("swapcol r"))
hl.bind(K(mod .. " + CTRL + L"),      hl.dsp.layout("swapcol r"))

-- Monitor Focus (Shift + Arrows / HJKL)
hl.bind(K(mod .. " + SHIFT + Left"),  hl.dsp.focus({ monitor = "-1" }))
hl.bind(K(mod .. " + SHIFT + H"),     hl.dsp.focus({ monitor = "-1" }))
hl.bind(K(mod .. " + SHIFT + Right"), hl.dsp.focus({ monitor = "+1" }))
hl.bind(K(mod .. " + SHIFT + L"),     hl.dsp.focus({ monitor = "+1" }))

-- Column Width Sizing (+ / -)
hl.bind(K(mod .. " + minus"),     hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })
hl.bind(K(mod .. " + equal"),     hl.dsp.window.resize({ x = 100,  y = 0, relative = true }), { repeating = true })

-- =============================================================================
-- WORKSPACES (Vertical switching like Niri & Noctalia - Independent per monitor)
-- =============================================================================
hl.bind(K(mod .. " + Up"),          hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus up"))
hl.bind(K(mod .. " + K"),           hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus up"))
hl.bind(K(mod .. " + Down"),        hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus down"))
hl.bind(K(mod .. " + J"),           hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus down"))

-- Move window to workspace Up / Down
hl.bind(K(mod .. " + CTRL + Up"),   hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri move up"))
hl.bind(K(mod .. " + CTRL + K"),    hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri move up"))
hl.bind(K(mod .. " + CTRL + Down"), hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri move down"))
hl.bind(K(mod .. " + CTRL + J"),    hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri move down"))

hl.bind(K(mod .. " + Page_Up"),     hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus up"))
hl.bind(K(mod .. " + Page_Down"),   hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus down"))
hl.bind(K(mod .. " + mouse_up"),    hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus up"))
hl.bind(K(mod .. " + mouse_down"),  hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus down"))
hl.bind(K(mod .. " + Tab"),         hl.dsp.focus({ workspace = "previous" }))

-- Workspace 1..9 (Độc lập theo từng màn hình giống Niri & Noctalia)
for i = 1, 9 do
    hl.bind(K(mod .. " + " .. i),          hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri focus " .. i))
    hl.bind(K(mod .. " + CTRL + " .. i),   hl.dsp.exec_cmd("~/.local/bin/ryoku-ws-niri move " .. i))
end

-- =============================================================================
-- APPS & LAUNCHERS
-- =============================================================================
hl.bind(K(mod .. " + Return"),    hl.dsp.exec_cmd("kitty"))
hl.bind(K(mod .. " + A"),         hl.dsp.exec_cmd("~/.local/bin/ryoku-launch-antigravity"))
hl.bind(K(mod .. " + I"),         hl.dsp.exec_cmd("code"))
hl.bind(K(mod .. " + E"),         hl.dsp.exec_cmd("ryoku-app files"))
hl.bind(K(mod .. " + B"),         hl.dsp.exec_cmd("zen-browser"))
hl.bind(K(mod .. " + SHIFT + B"), hl.dsp.exec_cmd("~/.local/bin/ryoku-bar-toggle"))
hl.bind(K(mod .. " + ALT + E"),   hl.dsp.exec_cmd("kitty -e yazi"))

hl.bind(K(mod .. " + Space"),     hl.dsp.global("ryoku:launcher"))
hl.bind(K(mod .. " + comma"),     hl.dsp.exec_cmd("ryoku-shell hub open"))
hl.bind(K(mod .. " + O"),         hl.dsp.global("ryoku:overview"))
hl.bind(K(mod .. " + V"),         hl.dsp.global("ryoku:clipboard"))
hl.bind(K(mod .. " + Escape"),    hl.dsp.global("ryoku:quicksettings"))
hl.bind(K(mod .. " + ALT + L"),   hl.dsp.exec_cmd("ryoku-shell lock"))
hl.bind(K(mod .. " + CTRL + L"),  hl.dsp.exec_cmd("ryoku-shell lock"))

-- Wallpapers & Animations
hl.bind(K(mod .. " + SHIFT + D"), hl.dsp.exec_cmd("qs -c shell ipc call picker wallpaper"))
hl.bind(K(mod .. " + W"),         hl.dsp.exec_cmd("qs -c shell ipc call picker wallpaper"))
hl.bind(K(mod .. " + SHIFT + W"), hl.dsp.exec_cmd("ryoku-shell wallpaper random"))

-- Mod + Shift + S: Chuyển đổi nhanh Preset Animation
hl.bind(K(mod .. " + SHIFT + S"), hl.dsp.exec_cmd("~/.local/bin/ryoku-anim-toggle"))

hl.bind(K(mod .. " + M"),         hl.dsp.exec_cmd("wl-mirror eDP-1"))

-- Screenshots (Interactive Layer-Shell Overlay: Ryoshot)
hl.bind(K("Print"),               hl.dsp.exec_cmd("flock -n -o /tmp/ryoshot.lock qs -c ryoshot"))
hl.bind(K(" ALT + S"),         hl.dsp.exec_cmd("flock -n -o /tmp/ryoshot.lock qs -c ryoshot"))
hl.bind(K("CTRL + SHIFT + 2"),    hl.dsp.exec_cmd("flock -n -o /tmp/ryoshot.lock env RYOSHOT_MODE=monitor qs -c ryoshot"))
hl.bind(K("CTRL + SHIFT + 3"),    hl.dsp.exec_cmd("flock -n -o /tmp/ryoshot.lock env RYOSHOT_MODE=window qs -c ryoshot"))

-- Mouse Drag / Resize
hl.bind(K(mod .. " + mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(K(mod .. " + mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Media & Brightness
hl.bind(K("XF86AudioRaiseVolume"), hl.dsp.exec_cmd("ryoku-volume up"),   { locked = true, repeating = true })
hl.bind(K("XF86AudioLowerVolume"), hl.dsp.exec_cmd("ryoku-volume down"), { locked = true, repeating = true })
hl.bind(K("XF86AudioMute"),        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind(K("XF86AudioPlay"),        hl.dsp.exec_cmd("playerctl play-pause"),                           { locked = true })
hl.bind(K("XF86AudioNext"),        hl.dsp.exec_cmd("playerctl next"),                                 { locked = true })
hl.bind(K("XF86AudioPrev"),        hl.dsp.exec_cmd("playerctl previous"),                             { locked = true })

hl.bind(K("XF86MonBrightnessUp"),   hl.dsp.exec_cmd("niri-brightness up"), { locked = true, repeating = true })
hl.bind(K("XF86MonBrightnessDown"), hl.dsp.exec_cmd("niri-brightness down"), { locked = true, repeating = true })
hl.bind(K("XF86KbdBrightnessUp"),   hl.dsp.exec_cmd("~/.local/bin/ryoku-kbd-brightness up"), { locked = true, repeating = true })
hl.bind(K("XF86KbdBrightnessDown"), hl.dsp.exec_cmd("~/.local/bin/ryoku-kbd-brightness down"), { locked = true, repeating = true })
