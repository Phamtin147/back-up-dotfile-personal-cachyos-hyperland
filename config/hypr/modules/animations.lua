-- Animation preset loader with instant live cache clearing
hl.config({ animations = { enabled = true } })

-- Standard Global Curves (luôn sẵn sàng cho mọi preset và user.lua)
hl.curve("smoothEase",     { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeOutCubic",   { type = "bezier", points = { { 0.215, 0.61 }, { 0.355, 1.0 } } })
hl.curve("easeOutExpo",    { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })

local function cfg(sub)
    local base = os.getenv("XDG_CONFIG_HOME")
    if not base or base == "" then
        base = (os.getenv("HOME") or "") .. "/.config"
    end
    return base .. sub
end

local function readName()
    local f = io.open(cfg("/ryoku/anim-preset"), "r")
    if not f then
        return "niri"
    end
    local n = (f:read("l") or ""):gsub("%s+", "")
    f:close()
    if n == "" or not n:match("^[%w%-_]+$") then
        return "niri"
    end
    return n
end

local name = readName()
local path = cfg("/hypr/modules/animations/" .. name .. ".lua")
local f = io.open(path, "r")
if f then
    f:close()
    for k in pairs(package.loaded) do
        if k:match("^modules%.animations") then
            package.loaded[k] = nil
        end
    end
    dofile(path)
else
    require("modules.animations.ryoku")
end
