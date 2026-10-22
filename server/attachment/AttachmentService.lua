local Attachment = require("server.attachment.Attachment")
local AttachmentParticle = require("server.attachment.AttachmentParticle")
local AttachmentSound = require("server.attachment.AttachmentSound")

local AttachmentService = {}
---@type table<number, table<string, S_Cfx_Attachment>>
AttachmentService._players = {}

AttachmentService.Attachment = Attachment
AttachmentService.AttachmentSound = AttachmentSound
AttachmentService.AttachmentParticle = AttachmentParticle

function AttachmentService:add(playerSource)
    -- Attachment:new
    -- AttachmentSound:new()
    -- AttachmentParticle:new()
end

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

    self:sync(playerSource)

    return attachment
end

---@param playerSource number
function AttachmentService:sync(playerSource)
    local serialized = {}

    for k, v in pairs(self._players[playerSource] or {}) do
        serialized[#serialized + 1] = v:serialize()
    end

    TriggerClientEvent("aqv::attachments::sync", -1, playerSource, serialized)

    -- Player(playerSource).state:set("atts", serialized, true)
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

    self:sync(playerSource)

    return true
end

return AttachmentService
