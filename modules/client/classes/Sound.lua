---@class C_Sound : OxClass
---@field private _id number
---@field private _audioName string
---@field private _audioRef string
local Sound = lib.class("C_Sound")

---@param audioName string
---@param audioRef string
function Sound:constructor(audioName, audioRef)
    self._id = -1
    self._audioName = audioName
    self._audioRef = audioRef
end

function Sound:getId()
    return self._id
end

function Sound:isPlaying()
    return self._id ~= -1
end

function Sound:stop()
    StopSound(self._id)

    self._id = -1
end

---@param entity number
---@param isNetwork boolean
function Sound:playFromEntity(entity, isNetwork)
    self._id = GetSoundId()

    PlaySoundFromEntity(self._id, self._audioName, entity, self._audioRef, isNetwork, false)
end

---@param position vector3
---@param range number
---@param isNetwork boolean
function Sound:playSoundAt(position, range, isNetwork)
    self._id = GetSoundId()

    PlaySoundFromCoord(
        self._id,
        self._audioName,
        position.x,
        position.y,
        position.z,
        self._audioRef,
        isNetwork,
        range,
        false
    )
end

function Sound:destroy()
    StopSound(self._id)

    ReleaseSoundId(self._id)
end

return Sound
