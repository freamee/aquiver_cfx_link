local lerp                   = require("shared.lerp")
local Tick                   = require("shared.Tick")
local Log                    = require("shared.Log")
local SmoothNumber           = require("shared.SmoothNumber")
local GetOffsetFromCoord     = require("shared.GetOffsetFromCoord")
local Transform              = require("shared.Transform")
local Color                  = require("shared.Color")
local Sequence               = require("shared.timing.sequence")
local Animation              = require("shared.animation.index")
local EventManager           = require("shared.events.EventManager")
local Timing                 = require("shared.timing.index")

CfxShared                    = {}

CfxShared.Debug              = false

CfxShared.GetOffsetFromCoord = GetOffsetFromCoord
CfxShared.lerp               = lerp
CfxShared.Tick               = Tick
CfxShared.Log                = Log
CfxShared.SmoothNumber       = SmoothNumber
CfxShared.Transform          = Transform
CfxShared.Color              = Color
CfxShared.Sequence           = Sequence
CfxShared.Timing             = Timing
CfxShared.Animation          = Animation
CfxShared.Events             = EventManager:new()

CfxShared.isShowcaseServer   = function()
    return GetConvarBool("aquiver_showcase_server", false)
end
