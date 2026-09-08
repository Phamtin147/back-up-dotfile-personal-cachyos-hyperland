-- Converted Shader Preset: morph
hl.curve("morphIn", { type = "bezier", points = { { 0.34, 1.3 }, { 0.64, 1.0 } } })
hl.curve("morphOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "morphIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "morphIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "morphIn", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "morphOut", style = "popin 70%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "morphIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "morphIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
