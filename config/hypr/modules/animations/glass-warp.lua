-- Converted Shader Preset: glass-warp
hl.curve("glass-warpIn", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("glass-warpOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 5.0, bezier = "glass-warpIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 5.0, bezier = "glass-warpIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5.0, bezier = "glass-warpIn", style = "slidefade 20%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4.2, bezier = "glass-warpOut", style = "slidefade 20%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5.0, bezier = "glass-warpIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "glass-warpIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
