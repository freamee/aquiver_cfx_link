---@class C_Sequence : OxClass
---@field private _events table
---@field private _running boolean
---@field private _cancelled boolean
---@field private _onComplete function?
---@field private _onCancel function?
---@field private _onError function?
local Sequence = lib.class("C_Sequence")

function Sequence:constructor()
    self._events = {}
    self._running = false
    self._cancelled = false
    self._onComplete = nil
    self._onCancel = nil
    self._onError = nil
end

---@param time number Milliseconds
---@param callback function
---@return C_Sequence
function Sequence:at(time, callback)
    self._events[#self._events + 1] = {
        time = time,
        callback = callback
    }

    return self
end

---@param callback function
---@return C_Sequence
function Sequence:onComplete(callback)
    self._onComplete = callback
    return self
end

---@param callback function
---@return C_Sequence
function Sequence:onCancel(callback)
    self._onCancel = callback
    return self
end

---@param callback function
---@return C_Sequence
function Sequence:onError(callback)
    self._onError = callback
    return self
end

---@return boolean
function Sequence:start()
    if self._running then
        return false
    end

    self._running = true
    self._cancelled = false

    table.sort(self._events, function(a, b)
        return a.time < b.time
    end)

    CreateThread(function()
        local startTime = GetGameTimer()

        for _, event in ipairs(self._events) do
            if self._cancelled then
                break
            end

            local elapsed = GetGameTimer() - startTime
            local remaining = event.time - elapsed

            if remaining > 0 then
                Wait(remaining)
            end

            if self._cancelled then
                break
            end

            local success, err = pcall(event.callback)

            if not success then
                self._running = false

                if self._onError then
                    self._onError(err)
                else
                    print("[Sequence] Error:", err)
                end

                return
            end
        end

        self._running = false

        if self._cancelled then
            if self._onCancel then
                self._onCancel()
            end
        elseif self._onComplete then
            self._onComplete()
        end
    end)

    return true
end

function Sequence:cancel()
    if not self._running then
        return
    end

    self._cancelled = true
end

---@return boolean
function Sequence:isRunning()
    return self._running
end

return Sequence
