---@class ISessionOptions
---@field id string
---@field startedAt number
---@field duration number
---@field expiresAt number
---@field data table
---@field onEnd? fun(reason: string, data: table)

---@class Session : OxClass
---@field private _sessions table<number, ISessionOptions>
---@field private _event EventHandler
local Session = lib.class("Session")

function Session:constructor()
    self._sessions = {}
    self._event = AddEventHandler("playerDropped", function()
        self:cancel(source)
    end)
end

---@private
---@param playerSource number
---@param reason string
function Session:_end(playerSource, reason)
    local session = self._sessions[playerSource]
    if not session then return false end

    self._sessions[playerSource] = nil

    if session.onEnd then
        session.onEnd(reason, session.data)
    end

    return true, session.data
end

---@param playerSource number
---@param id string
---@param duration number
---@param timeout? number
---@param data? table
---@param onEnd? fun(reason: string, data: table)
---@return boolean
function Session:start(playerSource, id, duration, timeout, data, onEnd)
    if self._sessions[playerSource] then
        return false
    end

    duration = math.max(0, duration)
    timeout = math.max(duration + 1000, timeout or duration + 10000)

    local session = {
        id = id,
        startedAt = GetGameTimer(),
        duration = duration,
        data = data,
        onEnd = onEnd
    }

    self._sessions[playerSource] = session

    SetTimeout(timeout, function()
        if self._sessions[playerSource] == session then
            self:_end(playerSource, "timeout")
        end
    end)

    return true
end

---@param playerSource number
---@param id string
---@return boolean, table
function Session:complete(playerSource, id)
    local session = self._sessions[playerSource]
    if not session then
        return false, {}
    end

    if session.id ~= id then
        return false, {}
    end

    local now = GetGameTimer()
    local elapsed = now - session.startedAt

    if now >= session.expiresAt then
        self:_end(playerSource, "timeout")
        return false, {}
    end

    if elapsed < session.duration then
        return false, {}
    end

    return self:_end(playerSource, "completed")
end

---@param playerSource number
---@return boolean
function Session:cancel(playerSource)
    return self:_end(playerSource, "cancelled")
end

---@param playerSource number
---@return boolean
function Session:isActive(playerSource)
    return self._sessions[playerSource] ~= nil
end

---@param playerSource number
---@return table?
function Session:get(playerSource)
    return self._sessions[playerSource]
end

return Session
