---@class C_AttachmentAPI : OxClass
---@field private _manager C_AttachmentManager
local AttachmentAPI = lib.class("C_AttachmentAPI")

---@param manager C_AttachmentManager
function AttachmentAPI:constructor(manager)
    self._manager = manager
end

---@param id string
---@param definition IAttachment
---@param ownerResource? string
function AttachmentAPI:createAttachment(id, definition, ownerResource)
    TriggerServerEvent("aquiver::attachments::create", id, definition, ownerResource)
    return true
end

---@param id string
---@param targetSource? number
function AttachmentAPI:getAttachment(id, targetSource)
    targetSource = tonumber(targetSource) or GetPlayerServerId(PlayerId())
    local attachment = self._manager:getAttachment(targetSource, id)

    if attachment then
        return attachment:getDefinition()
    end
end

---@param id string
---@param targetSource? number
function AttachmentAPI:getAttachmentEntity(id, targetSource)
    targetSource = tonumber(targetSource) or GetPlayerServerId(PlayerId())
    local attachment = self._manager:getAttachment(targetSource, id)

    if attachment then
        return attachment:getScriptId()
    end
end

-- Client mutations always apply to the calling player on the server.
local events = {
    destroyAttachment = "destroy",
    setAttachmentOffset = "setOffset",
    addAttachmentSound = "addSound",
    removeAttachmentSound = "removeSound",
    addAttachmentParticle = "addParticle",
    removeAttachmentParticle = "removeParticle",
    setAttachmentParticleOffset = "setParticleOffset",
}

for method, eventName in pairs(events) do
    AttachmentAPI[method] = function(self, ...)
        TriggerServerEvent("aquiver::attachments::" .. eventName, ...)
        return true
    end
end

return AttachmentAPI
