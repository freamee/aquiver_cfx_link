local lerp = require("shared.lerp")
local Tick = require("shared.Tick")
local Log = require("shared.Log")
local SmoothNumber = require("shared.SmoothNumber")

CfxShared = {}

CfxShared.Debug = false

CfxShared.lerp = lerp
CfxShared.Tick = Tick
CfxShared.Log = Log

CfxShared.SmoothNumber = SmoothNumber

CfxShared.isShowcaseServer = function()
    return GetConvarBool("aquiver_showcase_server", false)
end
