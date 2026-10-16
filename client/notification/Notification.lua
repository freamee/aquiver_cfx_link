local Graphics = require("client.Graphics")
local Tick = require("shared.Tick")

local Notification = {}
Notification._pops = {}
Notification._tick = Tick:new(function()
    Notification:onTick()
end, 0)
Notification._tick:start()

---@param message string
---@param duration number
---@param atPosition vector3
function Notification:pop(message, duration, atPosition)
    self._pops[NetworkGetNetworkIdFromEntity(PlayerPedId())] = {
        netId = NetworkGetNetworkIdFromEntity(PlayerPedId()),
        message = message,
        duration = duration,
        position = atPosition
    }
end

---@param serialize IPopNotificationSerialize
function Notification:addPop(serialize)
    self._pops[serialize.netId] = serialize
end

function Notification:onTick()
    local localPed = PlayerPedId()
    local localPosition = GetEntityCoords(localPed)
    local now = GetNetworkTime()

    for _, v in pairs(self._pops) do
        local targetPed = NetworkGetEntityFromNetworkId(v.netId)

        if DoesEntityExist(targetPed) then
            local elapsed = now - v.startAt
            local progress = math.min(elapsed / v.duration, 1.0)

            local height = progress * 1.0
            local alpha = math.floor(255 * (1.0 - progress))

            local drawPosition = vector3(
                v.position.x,
                v.position.y,
                v.position.z + height
            )

            Graphics:drawTextThisFrame3D(
                drawPosition,
                v.message,
                0.25,
                true,
                { 255, 255, 255, alpha }
            )
        end
    end
end

return Notification
