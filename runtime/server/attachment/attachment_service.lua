local ElementProp = require("runtime.server.attachment.element_prop")
local ElementSound = require("runtime.server.attachment.element_sound")
local ElementParticle = require("runtime.server.attachment.element_particle")
local Registry = require("runtime.server.attachment.attachment_registry")

local AttachmentService = {}

---@param targetSource number
---@param id string
---@param definition table
---@param ownerResource string
function AttachmentService:create(targetSource, id, definition, ownerResource)
    local attachment = ElementProp:new(
        id,
        definition.modelHash,
        ownerResource
    )

    for effectId, effect in pairs(definition.particles or {}) do
        local particle = ElementParticle:new(
            effectId,
            effect.dictionary,
            effect.name
        )

        attachment:addParticle(
            particle,
            effect.position,
            effect.rotation,
            effect.scale
        )
    end

    for effectId, effect in pairs(definition.sounds or {}) do
        local sound = ElementSound:new(
            effect.id,
            effect.audioName,
            effect.audioRef
        )

        attachment:addSound(sound)
    end

    local attached = attachment:attach(
        targetSource,
        definition.position,
        definition.rotation,
        definition.boneIndex
    )

    if not attached then
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
---@param soundId number
---@param audioName string
---@param audioRef string
function AttachmentService:addSound(targetSource, id, soundId, audioName, audioRef)
    local attachment = Registry:get(targetSource, id)

    if not attachment then
        return false
    end

    local sound = ElementSound:new(soundId, audioName, audioRef)

    return attachment:addSound(sound) ~= false
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

    return attachment:addParticle(particle, position, rotation, scale) ~= false
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

    particle:setOffset(position, rotation, scale)
    attachment:update()

    return true
end

return AttachmentService
