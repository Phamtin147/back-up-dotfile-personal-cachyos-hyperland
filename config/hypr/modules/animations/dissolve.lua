-- Converted Shader Preset: dissolve
hl.curve("dissolveIn", { type = "bezier", points = { { 0.2, 0.8 }, { 0.4, 1.0 } } })
hl.curve("dissolveOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 3.8, bezier = "dissolveIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 3.8, bezier = "dissolveIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.8, bezier = "dissolveIn", style = "fade" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.0, bezier = "dissolveOut", style = "fade" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.8, bezier = "dissolveIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "dissolveIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
