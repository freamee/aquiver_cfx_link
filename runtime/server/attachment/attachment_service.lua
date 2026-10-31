local ElementProp = require("runtime.server.attachment.element_prop")
local ElementSound = require("runtime.server.attachment.element_sound")
local ElementParticle = require("runtime.server.attachment.element_particle")
local Registry = require("runtime.server.attachment.attachment_registry")

local AttachmentService = {}

---@param targetSource number
---@param id string
---@param definition table
---@param ownerResource? string
function AttachmentService:create(targetSource, id, definition, ownerResource)
    local attachment = ElementProp:new(
        id,
        definition.modelHash,
        ownerResource
    )

    attachment:setCollisionState(definition.collision or false)

    for effectId, effect in pairs(definition.particles or {}) do
        local particle = ElementParticle:new(
            effect.id or effectId,
            effect.dictionary,
            effect.name
        )

        attachment:addParticle(
            particle,
            effect.position or effect.offsetPosition,
            effect.rotation or effect.offsetRotation,
            effect.scale
        )
    end

    for effectId, effect in pairs(definition.sounds or {}) do
        local sound = ElementSound:new(
            effect.id or effectId,
            effect.audioName,
            effect.audioRef
        )

        attachment:addSound(sound)
    end

    local attached = attachment:attach(
        targetSource,
        definition.position or definition.offsetPosition,
        definition.rotation or definition.offsetRotation,
        definition.boneIndex
    )

    if not attached then
        attachment:destroy()
        return nil
    end

    return attached:toDefinition()
end

---@param targetSource number
---@param id string
function AttachmentService:get(targetSource, id)
    local attachment = Registry:get(targetSource, id)

    if attachment then
        return attachment:toDefinition()
    end
end

---@param targetSource number
---@param id string
---@return boolean
function AttachmentService:destroy(targetSource, id)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    return attachment:destroy()
end

---@param targetSource number
---@param id string
---@param position vector3
---@param rotation vector3
---@param boneIndex number
---@return boolean
function AttachmentService:setOffset(targetSource, id, position, rotation, boneIndex)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    return attachment:setOffset(position, rotation, boneIndex)
end

---@param targetSource number
---@param id string
---@param soundId string
---@param audioName string
---@param audioRef string
function AttachmentService:addSound(targetSource, id, soundId, audioName, audioRef)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    local sound = ElementSound:new(soundId, audioName, audioRef)

    if not attachment:addSound(sound) then
        sound:destroy()
        return false
    end

    return true
end

---@param targetSource number
---@param id string
---@param soundId string
function AttachmentService:removeSound(targetSource, id, soundId)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    return attachment:removeSound(soundId)
end

---@param targetSource number
---@param id string
---@param particleId string
---@param dictionary string
---@param name string
---@param position vector3
---@param rotation vector3
---@param scale number
function AttachmentService:addParticle(targetSource, id, particleId, dictionary, name, position, rotation, scale)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    local particle = ElementParticle:new(particleId, dictionary, name)

    if not attachment:addParticle(particle, position, rotation, scale) then
        particle:destroy()
        return false
    end

    return true
end

---@param targetSource number
---@param id string
---@param particleId string
function AttachmentService:removeParticle(targetSource, id, particleId)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    return attachment:removeParticle(particleId)
end

---@param targetSource number
---@param id string
---@param particleId string
---@param position vector3
---@param rotation vector3
---@param scale number
function AttachmentService:setParticleOffset(targetSource, id, particleId, position, rotation, scale)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    local particle = attachment:getParticle(particleId)

    if not particle then
        return false
    end

    return particle:setOffset(position, rotation, scale)
end

return AttachmentService
