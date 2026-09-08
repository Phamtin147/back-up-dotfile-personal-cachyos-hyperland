-- Converted Shader Preset: inkwell-drop
hl.curve("inkwell-dropIn", { type = "bezier", points = { { 0.16, 1.15 }, { 0.24, 1.0 } } })
hl.curve("inkwell-dropOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "inkwell-dropIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "inkwell-dropIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "inkwell-dropIn", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "inkwell-dropOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "inkwell-dropIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "inkwell-dropIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
