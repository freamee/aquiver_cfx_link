local AttachmentRegistry = require("runtime.server.attachment.attachment_registry")
local AttachmentService = require("runtime.server.attachment.attachment_service")

exports("createAttachment", function(targetSource, id, definition)
    local ownerResource = GetInvokingResource() or GetCurrentResourceName()
    
    return AttachmentService:create(targetSource, id, definition, ownerResource)
end)

RegisterNetEvent("aquiver::attachments::create", function(id, definition, ownerResource)
    AttachmentService:create(source, id, definition, ownerResource or GetCurrentResourceName())
end)

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
