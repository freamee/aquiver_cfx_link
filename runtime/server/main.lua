local AttachmentRegistry = require("runtime.server.attachment.attachment_registry")
local AttachmentService = require("runtime.server.attachment.attachment_service")

exports("createAttachment", function(targetSource, id, definition)
    local ownerResource = GetInvokingResource() or GetCurrentResourceName()
    return AttachmentService:create(targetSource, id, definition, ownerResource)
end)

local methods = {
    getAttachment = "get",
    destroyAttachment = "destroy",
    setAttachmentOffset = "setOffset",
    addAttachmentSound = "addSound",
    removeAttachmentSound = "removeSound",
    addAttachmentParticle = "addParticle",
    removeAttachmentParticle = "removeParticle",
    setAttachmentParticleOffset = "setParticleOffset",
}

for exportName, method in pairs(methods) do
    exports(exportName, function(...)
        return AttachmentService[method](AttachmentService, ...)
    end)
end

RegisterNetEvent("aquiver::attachments::create", function(id, definition, ownerResource)
    AttachmentService:create(source, id, definition, ownerResource or GetCurrentResourceName())
end)

local events = {
    "destroy",
    "setOffset",
    "addSound",
    "removeSound",
    "addParticle",
    "removeParticle",
    "setParticleOffset",
}

for _, method in ipairs(events) do
    RegisterNetEvent("aquiver::attachments::" .. method, function(...)
        AttachmentService[method](AttachmentService, source, ...)
    end)
end

RegisterNetEvent("aquiver::attachments::requestSync", function()
    local state, revision = AttachmentRegistry:snapshot()
    TriggerClientEvent("aquiver::attachments::snapshot", source, state, revision)
end)

AddEventHandler("playerDropped", function()
    AttachmentRegistry:onPlayerQuit(source)
end)
AddEventHandler("onResourceStop", function(...)
    AttachmentRegistry:onResourceStop(...)
end)
