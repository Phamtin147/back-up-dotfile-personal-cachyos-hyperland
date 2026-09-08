-- Converted Shader Preset: pixelate
hl.curve("pixelateIn", { type = "bezier", points = { { 0.2, 0.8 }, { 0.4, 1.0 } } })
hl.curve("pixelateOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 3.2, bezier = "pixelateIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.2, bezier = "pixelateIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.2, bezier = "pixelateIn", style = "popin 30%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.4, bezier = "pixelateOut", style = "popin 30%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.2, bezier = "pixelateIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "pixelateIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
