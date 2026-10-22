local Prop = require("client.classes.Prop")

---@class C_Attachment : OxClass
---@field private _id string
---@field private _modelHash string
---@field private _offsetPosition vector3
---@field private _offsetRotation vector3
---@field private _boneIndex number
---@field private _collision boolean
---@field private _entity C_Prop
---@field private _children table<string, C_Attachment>
---@field private _sounds table<string, C_AttachmentSound>
---@field private _particles table<string, C_AttachmentParticle>
local Attachment = lib.class("C_Attachment")

---@param id string
function Attachment:constructor(id)
    self._id = id
    self._modelHash = "prop_wateringcan"
    self._offsetPosition = vector3(0, 0, 0)
    self._offsetRotation = vector3(0, 0, 0)
    self._boneIndex = -1
    self._collision = false
    self._entity = Prop:new(self._modelHash, vector3(0, 0, 0), vector3(0, 0, 0))
    self._children = {}
    self._sounds = {}
    self._particles = {}
end

function Attachment:getId()
    return self._id
end

function Attachment:getEntity()
    return self._entity
end

function Attachment:getModelHash()
    return self._modelHash
end

---@param modelHash string
function Attachment:setModelHash(modelHash)
    self._modelHash = modelHash
end

function Attachment:getCollisionState()
    return self._collision
end

---@param newState boolean
function Attachment:setCollisionState(newState)
    self._collision = newState
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

---@param particle C_AttachmentParticle
function Attachment:addPtfx(particle)
    self._particles[particle:getId()] = particle
end

function Attachment:removePtfx(id)
    self._particles[id] = nil
end

---@param id string
function Attachment:getPtfx(id)
    return self._particles[id]
end

---@param sound C_AttachmentSound
function Attachment:addSound(sound)
    self._sounds[sound:getId()] = sound
end

function Attachment:removeSound(id)
    self._sounds[id] = nil
end

---@param ped number
function Attachment:sync(ped)
    AttachEntityToEntity(
        self._entity:getScriptId(),
        ped,
        self._boneIndex,
        self._offsetPosition.x,
        self._offsetPosition.y,
        self._offsetPosition.z,
        self._offsetRotation.x,
        self._offsetRotation.y,
        self._offsetRotation.z,
        false,
        false,
        self._collision,
        false,
        2,
        true
    )
end

function Attachment:destroy()
    self._entity:destroy()
end

return Attachment
