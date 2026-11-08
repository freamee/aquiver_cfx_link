---@class LinearAnimation : OxClass
---@field private _value number
---@field private _from number
---@field private _target number
---@field private _duration number
---@field private _startedAt number
---@field private _playing boolean
---@field private _threadRunning boolean
---@field private _onChange? fun(value: number)
local Linear = lib.class("LinearAnimation")

---@param initialValue number
---@param duration? number Milliseconds
function Linear:constructor(initialValue, duration)
    self._value = initialValue
    self._from = initialValue
    self._target = initialValue
    self._duration = duration or 1000
    self._startedAt = 0
    self._playing = false
    self._threadRunning = false
    self._onChange = nil

    assert(self._duration > 0, "Invalid animation duration")
end

---@param callback fun(value: number)
function Linear:onChange(callback)
    self._onChange = callback

    if self._playing then
        self:_start()
    end

    return self
end

---@private
function Linear:_start()
    if self._threadRunning then return end

    self._threadRunning = true

    CreateThread(function()
        while self._playing do
            local value = self:get()

            if self._onChange then
                self._onChange(value)
            end

            if not self._playing then break end

            Wait(0)
        end

        self._threadRunning = false

        -- Handle an animation restarted before the worker exited.
        if self._playing and self._onChange then
            self:_start()
        end
    end)
end

---@param value number
---@param duration? number Milliseconds
function Linear:set(value, duration)
    local current = self:get()

    self._from = current
    self._target = value
    self._duration = duration or self._duration
    self._startedAt = GetGameTimer()
    self._playing = current ~= value

    assert(self._duration > 0, "Invalid animation duration")

    if not self._playing then
        self._value = value
    end

    if self._onChange then
        if self._playing then
            self:_start()
        else
            self._onChange(value)
        end
    end
end

---@return number
function Linear:get()
    if not self._playing then
        return self._value
    end

    local elapsed = GetGameTimer() - self._startedAt
    local progress = math.min(math.max(elapsed / self._duration, 0), 1)

    self._value = self._from +
        (self._target - self._from) * progress

    if progress >= 1 then
        self._value = self._target
        self._playing = false
    end

    return self._value
end

---@return number
function Linear:getTarget()
    return self._target
end

---@return boolean
function Linear:isPlaying()
    self:get()

    return self._playing
end

---@param value number
function Linear:reset(value)
    self._value = value
    self._from = value
    self._target = value
    self._playing = false

    if self._onChange then
        self._onChange(value)
    end
end

return Linear
