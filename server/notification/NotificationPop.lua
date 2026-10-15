local Notification = {}

---@param targetSource number
---@param message string
---@param duration number
function Notification:pop(targetSource, message, duration)
    local netId = NetworkGetNetworkIdFromEntity(targetSource)

    TriggerClientEvent("aquiver:notificationPop", -1, netId, message, duration)
end

-- function Notification:success(targetSource, message)
--     -- TriggerClientEvent("aquiver:no")
-- end

return Notification
