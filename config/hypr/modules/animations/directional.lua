-- Converted Shader Preset: directional
hl.curve("directionalIn", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("directionalOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 5.0, bezier = "directionalIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 5.0, bezier = "directionalIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5.0, bezier = "directionalIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4.2, bezier = "directionalOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5.0, bezier = "directionalIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "directionalIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
