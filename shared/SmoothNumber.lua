---@class SmoothNumber : OxClass
---@field private _value number
---@field private _target number
---@field private _speed number
---@field private _running boolean
---@field private _onUpdate fun(value: number)
local SmoothNumber = lib.class("SmoothNumber")

---@param value number
---@param speed number
---@param onUpdate fun(value: number)
function SmoothNumber:constructor(value, speed, onUpdate)
    self._value = value
    self._target = value
    self._onUpdate = onUpdate

    self._speed = speed or 2.0

    self._running = true

    self:_start()
end

---@private
function SmoothNumber:_start()
    Citizen.CreateThread(function()
        local lastTime = GetGameTimer()

        while self._running do
            Citizen.Wait(20)

            local now = GetGameTimer()
            local deltaTime = (now - lastTime) / 1000.0
            lastTime = now

            self:_update(deltaTime)
        end
    end)
end

---@private
---@param deltaTime number
function SmoothNumber:_update(deltaTime)
    local difference = self._target - self._value

    if math.abs(difference) < 0.01 then
        self._value = self._target
        self._onUpdate(self._value)
        return
    end

    local step = self._speed * deltaTime
    local direction = difference > 0 and 1 or -1

    if math.abs(difference) <= step then
        self._value = self._target
    else
        self._value = self._value + direction * step
    end

    self._onUpdate(self._value)
end

---@param target number
function SmoothNumber:setTarget(target)
    self._target = target
end

---@return number
function SmoothNumber:get()
    return self._value
end

---@return number
function SmoothNumber:getTarget()
    return self._target
end

---@param speed number
function SmoothNumber:setSpeed(speed)
    self._speed = speed
end

---@return number
function SmoothNumber:getSpeed()
    return self._speed
end

---@return boolean
function SmoothNumber:isComplete()
    return self._value == self._target
end

function SmoothNumber:destroy()
    self._running = false
end

return SmoothNumber
