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

RegisterNetEvent("SoundService::PlayAt", function(...)
    SoundService:playAt(...)
end)

return SoundService
