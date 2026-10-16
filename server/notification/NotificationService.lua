local NotificationService = {}

---@param targetSource number
---@param message string
---@param duration number
---@param atPosition vector3
function NotificationService:pop(targetSource, message, duration, atPosition)
    local ped = GetPlayerPed(targetSource)
    local netId = NetworkGetNetworkIdFromEntity(ped)

    ---@type IPopNotificationSerialize
    local serialize = {
        netId = netId,
        message = message,
        duration = duration,
        position = atPosition,
        startAt = GetGameTimer()
    }

    TriggerClientEvent("aquiver:notificationPop", -1, serialize)
end

return NotificationService
