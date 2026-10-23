---@class C_Animation : OxClass
---@field private _id string
---@field private _dictionary string
---@field private _name string
---@field private _blendInSpeed number
---@field private _blendOutSpeed number
---@field private _duration number
---@field private _flag number
---@field private _playbackRate number
---@field private _waitForFinish boolean
local Animation = lib.class("C_Animation")

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

    self._waitForFinish = false
end

function Animation:getId()
    return self._id
end

function Animation:getDictionary()
    return self._dictionary
end

function Animation:getName()
    return self._name
end

---@param newState boolean
function Animation:setWaitForFinish(newState)
    self._waitForFinish = newState

    return self
end

function Animation:getWaitForFinish()
    return self._waitForFinish
end

---@param duration number
function Animation:setDuration(duration)
    self._duration = duration

    return self
end

function Animation:getDuration()
    return self._duration
end

---@param flag number
function Animation:setFlag(flag)
    self._flag = flag

    return self
end

function Animation:getFlag()
    return self._flag
end

---@param speed number
function Animation:setPlaybackRate(speed)
    self._playbackRate = speed

    return self
end

function Animation:getPlaybackRate()
    return self._playbackRate
end

function Animation:getBlendInSpeed()
    return self._blendInSpeed
end

function Animation:getBlendOutSpeed()
    return self._blendOutSpeed
end

function Animation:getBlendSpeed()
    return self._blendInSpeed, self._blendOutSpeed
end

---@param blendIn number
---@param blendOut number
function Animation:setBlendSpeed(blendIn, blendOut)
    self._blendInSpeed = blendIn
    self._blendOutSpeed = blendOut

    return self
end

---@param ped number
function Animation:play(ped)
    lib.requestAnimDict(self._dictionary)

    TaskPlayAnim(
        ped,
        self._dictionary,
        self._name,
        self._blendInSpeed,
        self._blendOutSpeed,
        self._duration,
        self._flag,
        self._playbackRate,
        false,
        false,
        false
    )
end

---@param ped number
function Animation:stop(ped)
    StopAnimTask(
        ped,
        self._dictionary,
        self._name,
        self._blendOutSpeed
    )
end

return Animation
