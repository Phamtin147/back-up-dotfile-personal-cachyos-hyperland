-- Managed by ryoku-monitor (Ryoku Settings layout). The per-output modes are
-- the ones chosen in the Displays section; edits here may be overwritten.

hl.monitor({ output = "eDP-1", mode = "3072x1920@60.00", position = "0x0", scale = 1.6, cm = "srgb", bitdepth = 8, sdrbrightness = 1 })
hl.monitor({ output = "DP-5", mode = "1920x1200@60.00", position = "1920x0", scale = 1, cm = "srgb", bitdepth = 8, sdrbrightness = 1 })

-- Keep GTK and XWayland apps crisp (nearest whole scale when every monitor
-- agrees, else 1).
hl.env("GDK_SCALE", "1")

-- Catch-all for monitors not listed above. A hotplugged display comes up at
-- its highest resolution mode, placed to the right at 1x, never mirrored.
hl.monitor({ output = "", mode = "highres", position = "auto", scale = 1 })
