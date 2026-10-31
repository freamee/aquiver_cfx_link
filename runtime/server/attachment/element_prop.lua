local Element = require("runtime.server.attachment.element")
local Registry = require("runtime.server.attachment.attachment_registry")

---@class S_ElementProp : S_Element
---@field private _modelHash string | number
---@field private _ownerResource string
---@field private _targetSource number?
---@field private _particles table<string, S_ElementParticle>
---@field private _sounds table<string, S_ElementSound>
local ElementProp = lib.class("S_ElementProp", Element)

---@param id string
---@param modelHash string|number
---@param ownerResource? string
function ElementProp:constructor(id, modelHash, ownerResource)
    self:super(id)

    self._modelHash = modelHash
    self._ownerResource = ownerResource or GetInvokingResource() or GetCurrentResourceName()
    self._particles = {}
    self._sounds = {}
    self._position = vector3(0, 0, 0)
    self._rotation = vector3(0, 0, 0)
    self._boneIndex = -1
    self._collision = false
end

function ElementProp:getTargetSource()
    return self._targetSource
end

function ElementProp:getOwnerResource()
    return self._ownerResource
end

---@param enabled boolean
function ElementProp:setCollisionState(enabled)
    if self:isDestroyed() then
        return false
    end

    self._collision = enabled
    self:update()

    return true
end

function ElementProp:getCollisionState()
    return self._collision
end

---@param id string
function ElementProp:getParticle(id)
    return self._particles[id]
end

---@param id string
function ElementProp:getSound(id)
    return self._sounds[id]
end

---@param position? vector3
---@param rotation? vector3
---@param boneIndex? number
function ElementProp:setOffset(position, rotation, boneIndex)
    if self:isDestroyed() then
        return false
    end

    if position then
        self._position = vector3(position.x, position.y, position.z)
    end

    if rotation then
        self._rotation = vector3(rotation.x, rotation.y, rotation.z)
    end

    if boneIndex ~= nil then
        self._boneIndex = boneIndex
    end

    self:update()

    return true
end

function ElementProp:update()
    if not self:isDestroyed() and self._targetSource then
        Registry:publish(self._targetSource, self)
    end
end

---@param particle S_ElementParticle
---@param position? vector3
---@param rotation? vector3
---@param scale? number
function ElementProp:addParticle(particle, position, rotation, scale)
    if self:isDestroyed() or particle:isDestroyed() then
        return false
    end

    local owner = particle:getAttachment()

    if owner and owner ~= self then
        return false
    end

    if owner == self then
        particle:setOffset(position, rotation, scale)
        return self
    end

    local id = particle:getId()
    local previous = self._particles[id]

    if previous and previous ~= particle then
        previous:setAttachment(nil)
        previous:destroy()
    end

    particle:setOffset(position, rotation, scale)
    particle:setAttachment(self)

    self._particles[id] = particle

    self:update()

    return self
end

---@param sound S_ElementSound
function ElementProp:addSound(sound)
    if self:isDestroyed() or sound:isDestroyed() then
        return false
    end

    local owner = sound:getAttachment()

    if owner and owner ~= self then
        return false
    end

    local id = sound:getId()
    local previous = self._sounds[id]

    if previous and previous ~= sound then
        previous:setAttachment(nil)
        previous:destroy()
    end

    sound:setAttachment(self)

    self._sounds[id] = sound

    self:update()

    return self
end

---@param id string
function ElementProp:removeParticle(id)
    local particle = self._particles[id]

    if not particle then
        return false
    end

    self._particles[id] = nil

    particle:setAttachment(nil)

    self:update()

    return true
end

---@param id string
function ElementProp:removeSound(id)
    local sound = self._sounds[id]

    if not sound then
        return false
    end

    self._sounds[id] = nil

    sound:setAttachment(nil)

    self:update()

    return true
end

function ElementProp:toDefinition()
    if self:isDestroyed() then
        return nil
    end

    local definition = {
        id = self:getId(),
        modelHash = self._modelHash,
        position = vector3(self._position.x, self._position.y, self._position.z),
        rotation = vector3(self._rotation.x, self._rotation.y, self._rotation.z),
        boneIndex = self._boneIndex,
        collision = self._collision,
        particles = {},
        sounds = {},
    }

    for id, particle in pairs(self._particles) do
        definition.particles[id] = particle:toDefinition()
    end

    for id, sound in pairs(self._sounds) do
        definition.sounds[id] = sound:toDefinition()
    end

    return definition
end

---@param targetSource number
---@param position? vector3
---@param rotation? vector3
---@param boneIndex? number
function ElementProp:attach(targetSource, position, rotation, boneIndex)
    targetSource = tonumber(targetSource)
    if self:isDestroyed() or not targetSource or targetSource <= 0 then
        return false
    end

    if self._targetSource and self._targetSource ~= targetSource then
        Registry:remove(self._targetSource, self)
    end

    position = position or self._position
    rotation = rotation or self._rotation

    self._targetSource = targetSource
    self._position = vector3(position.x, position.y, position.z)
    self._rotation = vector3(rotation.x, rotation.y, rotation.z)
    self._boneIndex = boneIndex or self._boneIndex

    self:update()

    return self
end

function ElementProp:destroy()
    if self:isDestroyed() then
        return false
    end

    if self._targetSource then
        Registry:remove(self._targetSource, self)
        self._targetSource = nil
    end

    Element.destroy(self)

    for _, particle in pairs(self._particles) do
        particle:setAttachment(nil)
        particle:destroy()
    end

    for _, sound in pairs(self._sounds) do
        sound:setAttachment(nil)
        sound:destroy()
    end

    self._particles = {}
    self._sounds = {}
    return true
end

return ElementProp
