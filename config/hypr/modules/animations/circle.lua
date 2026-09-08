-- Converted Shader Preset: circle
hl.curve("circleIn", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("circleOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.8, bezier = "circleIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.8, bezier = "circleIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.8, bezier = "circleIn", style = "popin 10%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4.0, bezier = "circleOut", style = "popin 10%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.8, bezier = "circleIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "circleIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
