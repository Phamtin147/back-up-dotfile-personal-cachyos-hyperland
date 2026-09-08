-- Converted Shader Preset: polka-dots-curtain
hl.curve("polka-dots-curtainIn", { type = "bezier", points = { { 0.16, 1.15 }, { 0.24, 1.0 } } })
hl.curve("polka-dots-curtainOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "polka-dots-curtainIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "polka-dots-curtainIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "polka-dots-curtainIn", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "polka-dots-curtainOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "polka-dots-curtainIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "polka-dots-curtainIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
