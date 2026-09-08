local home = os.getenv("HOME")
local ok, wc = pcall(dofile, home .. "/.cache/ryoku/hypr-colors.lua")
if not ok then wc = nil end

local function border(hex, fallback)
  if type(hex) ~= "string" then hex = fallback end
  return "rgb(" .. hex:gsub("#", "") .. ")"
end

local active   = border(wc and wc.active, "#38bdf8")
local inactive = border(wc and wc.inactive, "#1e293b")

hl.config({
  general = {
    gaps_in                 = 6,
    gaps_out                = 8,
    border_size             = 2,
    layout                  = "scrolling",
    resize_on_border        = true,
    allow_tearing           = true,
    ["col.active_border"]   = active,
    ["col.inactive_border"] = inactive,
  },
  decoration = {
    rounding         = 8,
    rounding_power   = 2,
    active_opacity   = 0.98,
    inactive_opacity = 0.90,
    shadow = {
      enabled      = false,
    },
    blur = {
      enabled           = true,
      size              = 8,
      passes            = 2,
      vibrancy          = 0.25,
      noise             = 0.01,
      new_optimizations = true,
      xray              = true,
      popups            = true,
      popups_ignorealpha= 0.05,
    },
  },
})

-- Targeted layer rules with deep frosted glass blur for all popups
hl.layer_rule({ name = "ryoku-panels-blur", match = { namespace = "^ryoku-.*$" }, blur = true, ignore_alpha = 0.05, no_anim = true })
hl.layer_rule({ name = "quickshell-blur", match = { namespace = "^quickshell.*$" }, blur = true, ignore_alpha = 0.05, no_anim = true })
hl.layer_rule({ name = "launcher-blur", match = { namespace = "^launcher$" }, blur = true, ignore_alpha = 0.05, no_anim = true })
hl.layer_rule({ name = "overview-blur", match = { namespace = "overview" }, blur = true, no_anim = true })
hl.layer_rule({ name = "wallpaper-picker-blur", match = { namespace = "^ryoku-wallpaper-picker$" }, blur = true, ignore_alpha = 0.05, no_anim = true })
hl.layer_rule({ name = "osd-noanim", match = { namespace = "^ryoku-osd$" }, no_anim = true })
