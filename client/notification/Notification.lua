local Graphics = require("client.Graphics")
local Tick = require("shared.Tick")

local Notification = {}
Notification._pops = {}
Notification._tick = Tick:new(function()
    Notification:onTick()
end, 0)

---@param message string
---@param duration number
function Notification:pop(message, duration)
    self._pops[NetworkGetNetworkIdFromEntity(PlayerPedId())] = {
        netId = NetworkGetNetworkIdFromEntity(PlayerPedId()),
        message = message,
        duration = duration
    }
end

---@param serialize IPopNotificationSerialize
function Notification:addPop(serialize)
    self._pops[serialize.netId] = serialize
end

function Notification:onTick()
    local sleep = 500
    local now = GetGameTimer()
    local localPed = PlayerPedId()
    local localPosition = GetEntityCoords(localPed)

    for k, v in pairs(self._pops) do
        local targetPed = NetworkGetEntityFromNetworkId(v.netId)

        if DoesEntityExist(targetPed) then
            local targetPosition = GetEntityCoords(targetPed)
            local distanceTo = #(localPosition - targetPosition)

            if distanceTo < 20.0 then
                sleep = 0

                Graphics:drawTextThisFrame3D(
                    targetPosition,
                    json.encode(targetPosition),
                    0.2,
                    true
                )

                -- table.sort(pops, function(a, b) return a.created < b.created end)
                --                     for i, pop in ipairs(pops) do
                --                         local offset = (i - 1) * 0.18
                --                         local drawPos = head + vector3(0, 0, offset)
                --                         DrawText3D(drawPos, pop.text, pop.scale, pop.color)
                --                     end
            end
        end
    end

    Citizen.Wait(sleep)
end

return Notification
