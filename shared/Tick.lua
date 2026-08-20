---@class Tick : OxClass
---@field private _callback fun()
---@field private _interval number
---@field private _running boolean
local Tick = lib.class("Tick")

---@param callback fun(currentIteration: number)
---@param interval number
function Tick:constructor(callback, interval)
    self._callback = callback
    self._interval = interval
    self._running = false
end

function Tick:start()
    if self._running then
        return false
    end

    self._running = true

    Citizen.CreateThread(function()
        while self._running do
            self._callback()

            Citizen.Wait(self._interval)
        end
    end)

    return true
end

function Tick:stop()
    if not self._running then
        return false
    end

    self._running = false

    return true
end

function Tick:restart()
    self:stop()
    self:start()
end

function Tick:isRunning()
    return self._running
end

function Tick:getInterval()
    return self._interval
end

---@param interval number
function Tick:setInterval(interval)
    self._interval = interval
end

return Tick
