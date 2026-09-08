-- Converted Shader Preset: crt-tv
hl.curve("crt-tvIn", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("crt-tvOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 5.5, bezier = "crt-tvIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 5.5, bezier = "crt-tvIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5.5, bezier = "crt-tvIn", style = "popin 15%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4.7, bezier = "crt-tvOut", style = "popin 15%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5.5, bezier = "crt-tvIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "crt-tvIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
