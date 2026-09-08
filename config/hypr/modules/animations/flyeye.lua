-- Converted Shader Preset: flyeye
hl.curve("flyeyeIn", { type = "bezier", points = { { 0.16, 1.15 }, { 0.24, 1.0 } } })
hl.curve("flyeyeOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "flyeyeIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "flyeyeIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "flyeyeIn", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "flyeyeOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "flyeyeIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "flyeyeIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
