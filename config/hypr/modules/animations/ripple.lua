-- Converted Shader Preset: ripple
hl.curve("rippleIn", { type = "bezier", points = { { 0.34, 1.5 }, { 0.64, 1.0 } } })
hl.curve("rippleOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.2, bezier = "rippleIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.2, bezier = "rippleIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.2, bezier = "rippleIn", style = "popin 50%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.4, bezier = "rippleOut", style = "popin 50%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.2, bezier = "rippleIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "rippleIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
