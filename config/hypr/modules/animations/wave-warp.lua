-- Converted Shader Preset: wave-warp
hl.curve("wave-warpIn", { type = "bezier", points = { { 0.25, 1.2 }, { 0.5, 1.0 } } })
hl.curve("wave-warpOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.5, bezier = "wave-warpIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.5, bezier = "wave-warpIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.5, bezier = "wave-warpIn", style = "slidefade 35%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.7, bezier = "wave-warpOut", style = "slidefade 35%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.5, bezier = "wave-warpIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "wave-warpIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
