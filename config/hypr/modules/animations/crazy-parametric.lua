-- Converted Shader Preset: crazy-parametric
hl.curve("crazy-parametricIn", { type = "bezier", points = { { 0.16, 1.15 }, { 0.24, 1.0 } } })
hl.curve("crazy-parametricOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.0, bezier = "crazy-parametricIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.0, bezier = "crazy-parametricIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "crazy-parametricIn", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "crazy-parametricOut", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "crazy-parametricIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "crazy-parametricIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
