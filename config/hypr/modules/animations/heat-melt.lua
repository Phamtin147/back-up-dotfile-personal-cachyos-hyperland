-- Converted Shader Preset: heat-melt
hl.curve("heat-meltIn", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("heat-meltOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.2, bezier = "heat-meltIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.2, bezier = "heat-meltIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.2, bezier = "heat-meltIn", style = "slidefadevert 30%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.4, bezier = "heat-meltOut", style = "slidefadevert 30%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.2, bezier = "heat-meltIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "heat-meltIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
