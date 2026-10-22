---@class C_AttachmentSound : OxClass
---@field private _id string
---@field private _audioName string
---@field private _audioRef string
---@field private _entity number
local AttachmentSound = lib.class("C_AttachmentSound")

---@param id string
---@param audioName string
---@param audioRef string
function AttachmentSound:constructor(id, audioName, audioRef)
    self._id = id
    self._audioName = audioName
    self._audioRef = audioRef
    self._entity = -1
end

function AttachmentSound:getId()
    return self._id
end

---@param attachment C_Attachment
function AttachmentSound:play(attachment)
    self._entity = GetSoundId()

    PlaySoundFromEntity(
        self._entity,
        self._audioName,
        attachment:getEntity():getScriptId(),
        self._audioRef,
        false,
        false
    )
end

function AttachmentSound:destroy()
    StopSound(self._entity)
end

return AttachmentSound
