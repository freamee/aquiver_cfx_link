---@class S_Cfx_Animation : OxClass
---@field private _id string
---@field private _dictionary string
---@field private _name string
---@field private _blendInSpeed number
---@field private _blendOutSpeed number
---@field private _duration number
---@field private _flag number
---@field private _playbackRate number
local Animation = lib.class("S_Cfx_Animation")

---@param id string
---@param dictionary string
---@param name string
function Animation:constructor(id, dictionary, name)
    self._id = id
    self._dictionary = dictionary
    self._name = name

    self._blendInSpeed = 8.0
    self._blendOutSpeed = -8.0
    self._duration = -1
    self._flag = 1
    self._playbackRate = 1.0
end

function Animation:getId()
    return self._id
end

---@param duration number
function Animation:setDuration(duration)
    self._duration = duration
end

---@param flag number
function Animation:setFlag(flag)
    self._flag = flag
end

---@param speed number
function Animation:setPlaybackRate(speed)
    self._playbackRate = speed
end

---@param blendIn number
---@param blendOut number
function Animation:setBlendSpeed(blendIn, blendOut)
    self._blendInSpeed = blendIn
    self._blendOutSpeed = blendOut
end

function Animation:serialize()
    return {
        id = self._id,
        dictionary = self._dictionary,
        name = self._name,
        blendInSpeed = self._blendInSpeed,
        blendOutSpeed = self._blendOutSpeed,
        duration = self._duration,
        flag = self._flag,
        playbackRate = self._playbackRate
    }
end

return Animation
