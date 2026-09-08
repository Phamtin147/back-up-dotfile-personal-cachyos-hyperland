-- Converted Shader Preset: fadecolor
hl.curve("fadecolorIn", { type = "bezier", points = { { 0.16, 1.15 }, { 0.24, 1.0 } } })
hl.curve("fadecolorOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "fadecolorIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "fadecolorIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "fadecolorIn", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "fadecolorOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "fadecolorIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "fadecolorIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
