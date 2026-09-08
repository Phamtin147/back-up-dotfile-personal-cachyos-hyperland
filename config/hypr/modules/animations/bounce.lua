-- Converted Shader Preset: bounce
hl.curve("bounceIn", { type = "bezier", points = { { 0.34, 1.56 }, { 0.64, 1.0 } } })
hl.curve("bounceOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.5, bezier = "bounceIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.5, bezier = "bounceIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.5, bezier = "bounceIn", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.7, bezier = "bounceOut", style = "popin 60%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.5, bezier = "bounceIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "bounceIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
