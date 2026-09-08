-- Converted Shader Preset: smoke
hl.curve("smokeIn", { type = "bezier", points = { { 0.1, 0.9 }, { 0.2, 1.0 } } })
hl.curve("smokeOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "smokeIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "smokeIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "smokeIn", style = "slidefade 10%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "smokeOut", style = "slidefade 10%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "smokeIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "smokeIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
