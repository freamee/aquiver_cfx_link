---@class Session : OxClass
---@field private _sessions table<number, table>
---@field private _event EventHandler
local Session = lib.class("Session")

function Session:constructor()
    self._sessions = {}
    self._event = AddEventHandler("playerDropped", function()
        self:cancel(source)
    end)
end

---@param playerSource number
---@param id string
---@param duration number
---@param timeout? number
---@param data? table
---@return boolean
function Session:start(playerSource, id, duration, timeout, data)
    if self._sessions[playerSource] then
        return false
    end

    duration = math.max(0, duration)
    timeout = math.max(duration + 1000, timeout or duration + 10000)

    local session = {
        id = id,
        startedAt = GetGameTimer(),
        duration = duration,
        data = data
    }

    self._sessions[playerSource] = session

    SetTimeout(timeout, function()
        if self._sessions[playerSource] == session then
            self._sessions[playerSource] = nil
        end
    end)

    return true
end

---@param playerSource number
---@param id string
---@return boolean, table?
function Session:complete(playerSource, id)
    local session = self._sessions[playerSource]
    if not session then
        return false
    end

    if session.id ~= id then
        return false
    end

    local elapsed = GetGameTimer() - session.startedAt

    if elapsed < session.duration then
        return false
    end

    self._sessions[playerSource] = nil

    return true, session.data
end

---@param playerSource number
---@return boolean
function Session:cancel(playerSource)
    if not self._sessions[playerSource] then
        return false
    end

    self._sessions[playerSource] = nil

    return true
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