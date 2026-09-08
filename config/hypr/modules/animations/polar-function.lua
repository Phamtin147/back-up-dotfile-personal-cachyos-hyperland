-- Converted Shader Preset: polar-function
hl.curve("polar-functionIn", { type = "bezier", points = { { 0.16, 1.15 }, { 0.24, 1.0 } } })
hl.curve("polar-functionOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "polar-functionIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "polar-functionIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "polar-functionIn", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "polar-functionOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "polar-functionIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "polar-functionIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
