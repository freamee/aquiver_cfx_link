---@class C_AttachmentParticle : OxClass
---@field private _id string
---@field private _dictionary string
---@field private _name string
---@field private _scale number
---@field private _position vector3
---@field private _rotation vector3
---@field private _entity number
local AttachmentParticle = lib.class("C_AttachmentParticle")

---@param id string
---@param dictionary string
---@param name string
function AttachmentParticle:constructor(id, dictionary, name)
    self._id = id
    self._dictionary = dictionary
    self._name = name
    self._scale = 1.0
    self._position = vector3(0, 0, 0)
    self._rotation = vector3(0, 0, 0)
    self._entity = -1
end

function AttachmentParticle:getId()
    return self._id
end

function AttachmentParticle:getScale()
    return self._scale
end

---@param scale number
function AttachmentParticle:setScale(scale)
    self._scale = scale
end

---@param position vector3
function AttachmentParticle:setPosition(position)
    self._position = position
end

---@param rotation vector3
function AttachmentParticle:setRotation(rotation)
    self._rotation = rotation
end

---@param attachment C_Attachment
function AttachmentParticle:start(attachment)
    self._entity = StartParticleFxLoopedOnEntity(
        self._dictionary,
        attachment:getEntity():getScriptId(),
        self._position.x,
        self._position.y,
        self._position.z,
        self._rotation.x,
        self._rotation.y,
        self._rotation.z,
        self._scale,
        false,
        false,
        false
    )
end

function AttachmentParticle:destroy()
    StopParticleFxLooped(self._entity, false)
end

return AttachmentParticle
