---@class C_AttachmentParticle : OxClass
---@field private _id string
---@field private _dictionary string
---@field private _name string
---@field private _scale number
---@field private _position vector3
---@field private _rotation vector3
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

return AttachmentParticle
