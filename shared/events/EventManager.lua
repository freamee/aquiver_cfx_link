---@class EventManager : OxClass
local EventManager = lib.class("EventManager")

function EventManager:constructor()
    self._handlers = {}
end

---@param eventName string
---@param callback function
---@param networked? boolean
---@param once? boolean
---@return number
function EventManager:_register(eventName, callback, networked, once)
    if networked then
        RegisterNetEvent(eventName)
    end

    local handler

    handler = AddEventHandler(eventName, function(...)
        if once then
            self:off(handler)
        end

        if IsDuplicityVersion() and networked then
            local playerId = source

            if not playerId or playerId <= 0 then
                return
            end

            local player = Cfx.Player:get(playerId)

            if not player then
                return
            end

            callback(player, ...)
        else
            callback(...)
        end
    end)

    self._handlers[handler] = eventName

    return handler.key
end

function EventManager:on(eventName, callback)
    return self:_register(eventName, callback, false, false)
end

function EventManager:onNet(eventName, callback)
    return self:_register(eventName, callback, true, false)
end

function EventManager:once(eventName, callback)
    return self:_register(eventName, callback, false, true)
end

function EventManager:onceNet(eventName, callback)
    return self:_register(eventName, callback, true, true)
end

function EventManager:off(handlerId)
    if not self._handlers[handlerId] then
        return false
    end

    RemoveEventHandler(handlerId)

    self._handlers[handlerId] = nil

    return true
end

return EventManager
