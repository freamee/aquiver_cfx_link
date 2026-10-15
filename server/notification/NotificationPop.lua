local Notification = {}

---@param targetSource number
---@param message string
---@param duration number
function Notification:pop(targetSource, message, duration)
    local netId = NetworkGetNetworkIdFromEntity(targetSource)

    ---@type IPopNotificationSerialize
    local serialize = {
        netId = netId,
        message = message,
        duration = duration
    }

    TriggerClientEvent("aquiver:notificationPop", -1, serialize)
end

return Notification
