---@class C_Tween : OxClass
---@field private _from number|vector2|vector3|vector4
---@field private _to number|vector2|vector3|vector4
---@field private _duration number
---@field private _easing fun(t: number): number
---@field private _elapsed number
---@field private _startedAt number
---@field private _value number|vector2|vector3|vector4
---@field private _playing boolean
---@field private _paused boolean
---@field private _onUpdate? fun(value: any, progress: number)
---@field private _onComplete? fun()
---@field private _onStop? fun()
local Tween = lib.class("C_Tween")

local activeTweens = {}
local schedulerRunning = false

local Easing = {
    linear = function(t)
        return t
    end,

    easeInQuad = function(t)
        return t * t
    end,

    easeOutQuad = function(t)
        return 1 - (1 - t) ^ 2
    end,

    easeInOutQuad = function(t)
        if t < 0.5 then
            return 2 * t * t
        end

        return 1 - (-2 * t + 2) ^ 2 / 2
    end,

    easeInCubic = function(t)
        return t ^ 3
    end,

    easeOutCubic = function(t)
        return 1 - (1 - t) ^ 3
    end,

    easeInOutCubic = function(t)
        if t < 0.5 then
            return 4 * t ^ 3
        end

        return 1 - (-2 * t + 2) ^ 3 / 2
    end,

    easeOutBack = function(t)
        local c1 = 1.70158
        local c3 = c1 + 1

        return 1 + c3 * (t - 1) ^ 3 + c1 * (t - 1) ^ 2
    end
}

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function getElapsed(tween)
    if not tween._playing or tween._paused then
        return tween._elapsed
    end

    return math.min(
        tween._elapsed + GetGameTimer() - tween._startedAt,
        tween._duration
    )
end

local function updateValue(tween)
    local progress = clamp(
        getElapsed(tween) / tween._duration,
        0,
        1
    )

    tween._value = tween._from +
        (tween._to - tween._from) * tween._easing(progress)

    return progress
end

local function startScheduler()
    if schedulerRunning then return end

    schedulerRunning = true

    CreateThread(function()
        while next(activeTweens) do
            local snapshot = {}

            for tween in pairs(activeTweens) do
                snapshot[#snapshot + 1] = tween
            end

            for i = 1, #snapshot do
                local tween = snapshot[i]

                if activeTweens[tween] and tween._playing and not tween._paused then
                    local progress = updateValue(tween)

                    if tween._onUpdate then
                        tween._onUpdate(tween._value, progress)
                    end

                    if activeTweens[tween] and tween._playing and not tween._paused
                        and progress >= 1 then
                        tween._elapsed = tween._duration
                        tween._playing = false
                        activeTweens[tween] = nil

                        if tween._onComplete then
                            tween._onComplete()
                        end
                    end
                end
            end

            Wait(0)
        end

        schedulerRunning = false
    end)
end

---@param from number|vector2|vector3|vector4
---@param to number|vector2|vector3|vector4
---@param duration number Milliseconds
---@param easing? string
function Tween:constructor(from, to, duration, easing)
    assert(type(from) == type(to), "Tween types must match")
    assert(
        type(from) == "number" or
        type(from) == "vector2" or
        type(from) == "vector3" or
        type(from) == "vector4",
        "Unsupported tween type"
    )
    assert(type(duration) == "number" and duration > 0, "Invalid duration")

    self._easing = assert(
        Easing[easing or "linear"],
        "Invalid tween easing"
    )

    self._from = from
    self._to = to
    self._duration = duration
    self._elapsed = 0
    self._startedAt = 0
    self._value = from
    self._playing = false
    self._paused = false
end

---@param callback fun(value: any, progress: number)
---@return C_Tween
function Tween:onUpdate(callback)
    self._onUpdate = callback
    return self
end

---@param callback fun()
---@return C_Tween
function Tween:onComplete(callback)
    self._onComplete = callback
    return self
end

---@param callback fun()
---@return C_Tween
function Tween:onStop(callback)
    self._onStop = callback
    return self
end

---@return C_Tween
function Tween:play()
    if self._playing then return self end

    self._elapsed = 0
    self._startedAt = GetGameTimer()
    self._value = self._from
    self._playing = true
    self._paused = false

    activeTweens[self] = true
    startScheduler()

    return self
end

---@return C_Tween
function Tween:pause()
    if not self._playing or self._paused then
        return self
    end

    self._elapsed = getElapsed(self)
    self._paused = true

    return self
end

---@return C_Tween
function Tween:resume()
    if not self._playing or not self._paused then
        return self
    end

    self._startedAt = GetGameTimer()
    self._paused = false

    return self
end

---@return C_Tween
function Tween:stop()
    if not self._playing then return self end

    self._elapsed = getElapsed(self)
    self._playing = false
    self._paused = false
    activeTweens[self] = nil

    if self._onStop then
        self._onStop()
    end

    return self
end

---@return C_Tween
function Tween:restart()
    activeTweens[self] = nil
    self._playing = false
    self._paused = false

    return self:play()
end

---@return C_Tween
function Tween:reverse()
    local progress = self:getProgress()
    local currentValue = self._from +
        (self._to - self._from) * self._easing(progress)

    local previousFrom = self._from

    self._from = currentValue
    self._to = previousFrom
    self._elapsed = 0
    self._startedAt = GetGameTimer()
    self._value = currentValue

    return self
end

---@return number
function Tween:getProgress()
    return clamp(getElapsed(self) / self._duration, 0, 1)
end

---@return number|vector2|vector3|vector4
function Tween:getValue()
    return self._value
end

---@return boolean
function Tween:isPlaying()
    return self._playing and not self._paused
end

---@return boolean
function Tween:isPaused()
    return self._playing and self._paused
end

return Tween
