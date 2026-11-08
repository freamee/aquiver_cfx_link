---@class SmoothAnimation : OxClass
---@field private _value number
---@field private _from number
---@field private _target number
---@field private _duration number
---@field private _startedAt number
---@field private _playing boolean
---@field private _threadRunning boolean
---@field private _onChange? fun(value: number)
local Smooth = lib.class("SmoothAnimation")

---@param initialValue number
---@param duration? number Milliseconds
function Smooth:constructor(initialValue, duration)
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
function Smooth:onChange(callback)
    self._onChange = callback

    if self._playing then
        self:_start()
    end

    return self
end

---@private
function Smooth:_start()
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

        if self._playing and self._onChange then
            self:_start()
        end
    end)
end

---@param value number
---@param duration? number Milliseconds
function Smooth:set(value, duration)
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
function Smooth:get()
    if not self._playing then
        return self._value
    end

    local elapsed = GetGameTimer() - self._startedAt
    local progress = math.min(math.max(elapsed / self._duration, 0), 1)

    local smooth = progress * progress * (3 - 2 * progress)

    self._value = self._from +
        (self._target - self._from) * smooth

    if progress >= 1 then
        self._value = self._target
        self._playing = false
    end

    return self._value
end

---@return number
function Smooth:getTarget()
    return self._target
end

---@return boolean
function Smooth:isPlaying()
    self:get()

    return self._playing
end

---@param value number
function Smooth:reset(value)
    self._value = value
    self._from = value
    self._target = value
    self._playing = false

    if self._onChange then
        self._onChange(value)
    end
end

return Smooth
