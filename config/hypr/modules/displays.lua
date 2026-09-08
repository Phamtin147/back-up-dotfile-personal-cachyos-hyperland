-- A hotplug redoes DPI autoscale and repaints the wallpaper.
local function rescale()
    hl.exec_cmd("command -v ryoku-monitor >/dev/null 2>&1 && ryoku-monitor autoscale")
    hl.exec_cmd("command -v ryoku-shell >/dev/null 2>&1 && { sleep 1; ryoku-shell wallpaper refresh; }")
end
hl.on("monitor.added", rescale)
hl.on("monitor.removed", rescale)

-- Dynamic & Infinite Workspaces strictly isolated per Monitor (Niri / Noctalia layout)
-- Monitor 0 (Built-in eDP-1): Workspaces 1 -> 500 (default: 1)
hl.workspace_rule({ workspace = "r[1-500]", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })

-- Monitor 1 (Any External Display DP-1..10, HDMI-A-1..5): Workspaces 501 -> 1000 (default: 501)
local ext_displays = {
    "DP-1", "DP-2", "DP-3", "DP-4", "DP-5", "DP-6", "DP-7", "DP-8", "DP-9", "DP-10",
    "HDMI-A-1", "HDMI-A-2", "HDMI-A-3", "HDMI-A-4", "HDMI-A-5"
}

for _, port in ipairs(ext_displays) do
    hl.workspace_rule({ workspace = "r[501-1000]", monitor = port })
    hl.workspace_rule({ workspace = "501", monitor = port, default = true })
end
