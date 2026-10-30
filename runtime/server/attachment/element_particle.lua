local Element = require("runtime.server.attachment.element")

---@class S_ElementParticle : S_Element
---@field private _dictionary string
---@field private _name string
---@field private _position vector3
---@field private _rotation vector3
---@field private _scale number
local ElementParticle = lib.class("S_ElementParticle", Element)

---@param id string
---@param dictionary string
---@param name string
function ElementParticle:constructor(id, dictionary, name)
    self:super(id)

    self._dictionary = dictionary
    self._name = name
    self._position = vector3(0, 0, 0)
    self._rotation = vector3(0, 0, 0)
    self._scale = 1.0
end

---@param position? vector3
---@param rotation? vector3
---@param scale? number
function ElementParticle:setOffset(position, rotation, scale)
    if self:isDestroyed() then
        return false
    end

    if position then
        self._position = vector3(position.x, position.y, position.z)
    end

    if rotation then
        self._rotation = vector3(rotation.x, rotation.y, rotation.z)
    end

    if scale ~= nil then
        self._scale = scale
    end

    return true
end

function ElementParticle:toDefinition()
    if self:isDestroyed() then
        return nil
    end

    return {
        id = self:getId(),
        dictionary = self._dictionary,
        name = self._name,
        position = vector3(self._position.x, self._position.y, self._position.z),
        rotation = vector3(self._rotation.x, self._rotation.y, self._rotation.z),
        scale = self._scale,
    }
end

---@param targetSource number
---@param attachment S_ElementProp
---@param position? vector3
---@param rotation? vector3
---@param scale? number
function ElementParticle:attach(targetSource, attachment, position, rotation, scale)
    local attachmentSource = attachment:getTargetSource()

    if attachmentSource and attachmentSource ~= targetSource then
        return false
    end

    return attachment:addParticle(self, position, rotation, scale)
end

function ElementParticle:destroy()
    if self:isDestroyed() then
        return false
    end

    local attachment = self:getAttachment()

    if attachment then
        attachment:removeParticle(self:getId())
    end

    self._destroyed = true

    return true
end

return ElementParticle
