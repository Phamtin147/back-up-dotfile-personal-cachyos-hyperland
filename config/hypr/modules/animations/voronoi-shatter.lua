-- Converted Shader Preset: voronoi-shatter
hl.curve("voronoi-shatterIn", { type = "bezier", points = { { 0.05, 0.95 }, { 0.15, 1.05 } } })
hl.curve("voronoi-shatterOut", { type = "bezier", points = { { 0.25, 1.0 }, { 0.5, 1.0 } } })

hl.animation({ leaf = "global", enabled = true, speed = 4.6, bezier = "voronoi-shatterIn" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.6, bezier = "voronoi-shatterIn" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.6, bezier = "voronoi-shatterIn", style = "popin 65%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.8, bezier = "voronoi-shatterOut", style = "popin 65%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.6, bezier = "voronoi-shatterIn" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.5, bezier = "voronoi-shatterIn" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slidevert" })
