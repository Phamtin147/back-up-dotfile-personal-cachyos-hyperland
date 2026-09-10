-- Hand-written manual monitor overrides
-- MacBook Pro Retina Internal Display (eDP-1)
hl.monitor({ output = "eDP-1", mode = "3072x1920@60.00", position = "0x0", scale = 2.0, cm = "srgb", bitdepth = 8, sdrbrightness = 1 })

-- External Monitor (DP-5 / other external displays placed to the right)
hl.monitor({ output = "DP-5", mode = "preferred", position = "1536x0", scale = 1.0, cm = "srgb", bitdepth = 8, sdrbrightness = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto-right", scale = 1.0 })

hl.env("GDK_SCALE", "2")
