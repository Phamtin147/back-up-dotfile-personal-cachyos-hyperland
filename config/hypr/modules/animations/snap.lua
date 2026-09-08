-- Converted Shader Preset: snap
hl.curve("snapIn", { type = "bezier", points = { { 0.0, 1.0 }, { 0.0, 1.0 } } })
hl.curve("snapOut", { type = "bezier", points = { { 0.0, 1.0 }, { 0.0, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 1.5, bezier = "snapIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 1.5, bezier = "snapIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.5, bezier = "snapIn", style = "popin 95%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "snapOut", style = "popin 95%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.5, bezier = "snapIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "snapIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
