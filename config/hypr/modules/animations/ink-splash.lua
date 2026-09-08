-- Converted Shader Preset: ink-splash
hl.curve("ink-splashIn", { type = "bezier", points = { { 0.16, 1.2 }, { 0.3, 1.0 } } })
hl.curve("ink-splashOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.5, bezier = "ink-splashIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.5, bezier = "ink-splashIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.5, bezier = "ink-splashIn", style = "popin 40%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.7, bezier = "ink-splashOut", style = "popin 40%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.5, bezier = "ink-splashIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "ink-splashIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
