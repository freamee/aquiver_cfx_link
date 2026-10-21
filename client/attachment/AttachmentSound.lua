---@class C_AttachmentSound : OxClass
---@field private _id string
---@field private _audioName string
---@field private _audioRef string
local AttachmentSound = lib.class("C_AttachmentSound")

---@param id string
---@param audioName string
---@param audioRef string
function AttachmentSound:constructor(id, audioName, audioRef)
    self._id = id
    self._audioName = audioName
    self._audioRef = audioRef
end

function AttachmentSound:getId()
    return self._id
end

return AttachmentSound
