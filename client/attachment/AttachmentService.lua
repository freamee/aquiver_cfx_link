local Attachment = require("client.attachment.Attachment")
local AttachmentParticle = require("client.attachment.AttachmentParticle")

local AttachmentService = {}
---@type table<number, table<string, C_Attachment>>
AttachmentService._entities = {}

---@param id string
---@param position vector3
---@param rotation vector3
---@param boneIndex number
function AttachmentService:modify(id, position, rotation, boneIndex)

end

---@param targetSource number
---@param data IAttachment
function AttachmentService:sync(targetSource, data)
    local targetPed = GetPlayerPed(targetSource)
    if not DoesEntityExist(targetPed) then return end

    if not self._entities[targetPed] then
        self._entities[targetPed] = {}
    end

    local entities = self._entities[targetPed] or {}
    local entity = entities[data.id]

    if not entity then
        entity = Attachment:new(data.id)
    end

    entity:setModelHash(data.modelHash)
    entity:setCollisionState(data.collision)
    entity:setOffsetPosition(data.offsetPosition)
    entity:setOffsetRotation(data.offsetRotation)
    entity:setBoneIndex(data.boneIndex)

    entity:sync(targetPed)

    for _, ctx in pairs(data.particles) do
        local ptfx = entity:getPtfx(ctx.id)

        if not ptfx then
            ptfx = AttachmentParticle:new(
                ctx.id,
                ctx.dictionary,
                ctx.name
            )
        end

        ptfx:setPosition(ctx.position)
        ptfx:setRotation(ctx.rotation)
        ptfx:setScale(ctx.scale)

        ptfx:start(entity)

        entity:addPtfx(ptfx)
    end

    entities[targetPed][data.id] = entity
end

return AttachmentService
