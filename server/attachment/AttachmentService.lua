local Attachment = require("lua.server.Attachment.Attachment")

local AttachmentService = {}
---@type table<number, table<string, S_Cfx_Attachment>>
AttachmentService._players = {}

---@param playerSource number
---@param id string
---@param modelHash string
---@param offsetPosition vector3
---@param offsetRotation vector3
---@param boneIndex number
---@param collision boolean
function AttachmentService:create(playerSource, id, modelHash, offsetPosition, offsetRotation, boneIndex, collision)
    local attachment = Attachment:new(id, modelHash, offsetPosition, offsetRotation)

    attachment:setBoneIndex(boneIndex)
    attachment:setCollisionState(collision)

    self._players[playerSource] = self._players[playerSource] or {}
    self._players[playerSource][id] = attachment

    self:sync(playerSource, attachment)

    return attachment
end

---@param playerSource number
---@param id string
---@param offsetPosition vector3
---@param offsetRotation vector3
---@param boneIndex any
---@param collision any
function AttachmentService:update(playerSource, id, offsetPosition, offsetRotation, boneIndex, collision)
    local entities = self._players[playerSource]
    if not entities then return false end

    local attachment = entities[id]
    if not attachment then return false end

    attachment:setOffsetPosition(offsetPosition)
    attachment:setOffsetRotation(offsetRotation)
    attachment:setBoneIndex(boneIndex)
    attachment:setCollisionState(collision)

    self:sync(playerSource, attachment)

    return true
end

---@param playerSource number
---@param attachment S_Cfx_Attachment
function AttachmentService:sync(playerSource, attachment)
    TriggerClientEvent(
        "AttachmentService::Create",
        playerSource,
        attachment:serialize()
    )
end

---@param playerSource number
---@param id string
function AttachmentService:remove(playerSource, id)
    local entities = self._players[playerSource]
    if not entities then
        return false
    end

    local attachment = entities[id]
    if not attachment then
        return false
    end

    entities[id] = nil

    TriggerClientEvent("AttachmentService::Remove", playerSource, id)

    return true
end

return AttachmentService
