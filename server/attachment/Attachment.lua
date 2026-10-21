---@class S_Cfx_Attachment : OxClass
---@field private _id string
---@field private _modelHash string
---@field private _offsetPosition vector3
---@field private _offsetRotation vector3
---@field private _boneIndex number
---@field private _collision boolean
---@field private _children table<string, S_Cfx_Attachment>
---@field private _particles table<string, S_AttachmentParticle>
---@field private _sounds table<string, S_AttachmentSound>
local Attachment = lib.class("S_Cfx_Attachment")

---@param id string
---@param modelHash string
---@param offsetPosition vector3
---@param offsetRotation vector3
function Attachment:constructor(id, modelHash, offsetPosition, offsetRotation)
    self._id = id
    self._modelHash = modelHash
    self._offsetPosition = offsetPosition
    self._offsetRotation = offsetRotation
    self._boneIndex = -1
    self._collision = false
    self._children = {}
    self._particles = {}
    self._sounds = {}
end

function Attachment:getId()
    return self._id
end

function Attachment:getOffsetPosition()
    return self._offsetPosition
end

function Attachment:getOffsetRotation()
    return self._offsetRotation
end

---@param offsetPosition vector3
function Attachment:setOffsetPosition(offsetPosition)
    self._offsetPosition = offsetPosition
end

---@param offsetRotation vector3
function Attachment:setOffsetRotation(offsetRotation)
    self._offsetRotation = offsetRotation
end

function Attachment:getBoneIndex()
    return self._boneIndex
end

---@param boneIndex number
function Attachment:setBoneIndex(boneIndex)
    self._boneIndex = boneIndex
end

function Attachment:getCollisionState()
    return self._collision
end

---@param newState boolean
function Attachment:setCollisionState(newState)
    self._collision = newState
end

---@param particle S_AttachmentParticle
function Attachment:addParticle(particle)
    self._particles[particle:getId()] = particle
end

function Attachment:removeParticle(id)
    self._particles[id] = nil
end

---@param sound S_AttachmentSound
function Attachment:addSound(sound)
    self._sounds[sound:getId()] = sound
end

function Attachment:removeSound(id)
    self._sounds[id] = nil
end

---@param attachment S_Cfx_Attachment
function Attachment:addChild(attachment)
    self._children[attachment:getId()] = attachment

    return attachment
end

---@param id string
function Attachment:getChild(id)
    return self._children[id]
end

---@param id string
function Attachment:removeChild(id)
    self._children[id] = nil
end

function Attachment:serialize()
    local childrenSerialized = {}
    local particleSerialized = {}
    local soundSerialized = {}

    for id, children in pairs(self._children) do
        childrenSerialized[children:getId()] = children:serialize()
    end

    for k, v in pairs(self._particles) do
        particleSerialized[#particleSerialized + 1] = v:serialize()
    end

    for k, v in pairs(self._sounds) do
        soundSerialized[#soundSerialized + 1] = v:serialize()
    end

    return {
        id = self._id,
        modelHash = self._modelHash,
        offsetPosition = self._offsetPosition,
        offsetRotation = self._offsetRotation,
        boneIndex = self._boneIndex,
        collision = self._collision,
        children = childrenSerialized,
        particles = particleSerialized,
        sounds = soundSerialized
    }
end

return Attachment
