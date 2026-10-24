local SoundService = {}

---@param position vector3
---@param range number
---@param audioName string
---@param audioRef string
function SoundService:playAt(position, range, audioName, audioRef)
    local soundId = GetSoundId()

    PlaySoundFromCoord(
        soundId,
        audioName,
        position.x,
        position.y,
        position.z,
        audioRef,
        false,
        range,
        false
    )

    ReleaseSoundId(soundId)
end

--- Sends an event to the server and broadcast it to the nearby players in range.
---@param position vector3
---@param range number
---@param audioName string
---@param audioRef string
function SoundService:playAtNet(position, range, audioName, audioRef)
    TriggerServerEvent("aqv:sound:playNet", position, range, audioName, audioRef)
end

RegisterNetEvent("aqv:sound:playAt", function(...)
    SoundService:playAt(...)
end)

return SoundService
