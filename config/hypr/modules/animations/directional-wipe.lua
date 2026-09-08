-- Converted Shader Preset: directional-wipe
hl.curve("directional-wipeIn", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("directional-wipeOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.8, bezier = "directional-wipeIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.8, bezier = "directional-wipeIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.8, bezier = "directional-wipeIn", style = "slidefade 50%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4.0, bezier = "directional-wipeOut", style = "slidefade 50%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.8, bezier = "directional-wipeIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "directional-wipeIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
