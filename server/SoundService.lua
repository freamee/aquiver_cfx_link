local SoundService = {}

---@param position vector3
---@param dimension number
---@param range number
---@param audioName string
---@param audioRef string
function SoundService:playAt(position, dimension, range, audioName, audioRef)
    local nearby = lib.getNearbyPlayers(position, range)

    for _, player in pairs(nearby) do
        local targetSource = player.id

        if GetPlayerRoutingBucket(targetSource) ~= dimension then return end

        TriggerClientEvent(
            "aqv:sound:playAt",
            targetSource,
            position,
            range,
            audioName,
            audioRef
        )
    end
end

return SoundService
