-- Converted Shader Preset: glitch
hl.curve("glitchIn", { type = "bezier", points = { { 0.0, 1.25 }, { 0.1, 1.0 } } })
hl.curve("glitchOut", { type = "bezier", points = { { 0.1, 1.0 }, { 0.2, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 2.5, bezier = "glitchIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 2.5, bezier = "glitchIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.5, bezier = "glitchIn", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.7, bezier = "glitchOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2.5, bezier = "glitchIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "glitchIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
