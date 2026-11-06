local Smooth = require("shared.animation.Smooth")
local Linear = require("shared.animation.Linear")

---@class SmoothNumber : OxClass
---@field private _animation LinearAnimation
---@field private _target number
---@field private _speed number
local SmoothNumber = lib.class("SmoothNumber")

---@param value number
---@param speed? number
function SmoothNumber:constructor(value, speed)
    self._target = value
    self._speed = speed or 2.0

    assert(self._speed > 0, "Speed must be positive")

    self._animation = Linear:new(value)
end

---@param target number
function SmoothNumber:setTarget(target)
    if self._target == target then return end

    local current = self._animation:get()
    local distance = math.abs(target - current)

    self._target = target

    if distance < 0.01 then
        self._animation:reset(target)
        return
    end

    local duration = (distance / self._speed) * 1000

    self._animation:set(target, duration)
end

---@return number
function SmoothNumber:get()
    return self._animation:get()
end

---@return number
function SmoothNumber:getTarget()
    return self._target
end

---@param speed number
function SmoothNumber:setSpeed(speed)
    assert(speed > 0, "Speed must be positive")

    self._speed = speed

    if self._animation:isPlaying() then
        local current = self._animation:get()
        local distance = math.abs(self._target - current)

        if distance > 0 then
            self._animation:set(
                self._target,
                (distance / speed) * 1000
            )
        end
    end
end

---@return number
function SmoothNumber:getSpeed()
    return self._speed
end

---@return boolean
function SmoothNumber:isComplete()
    return not self._animation:isPlaying()
end

return SmoothNumber
