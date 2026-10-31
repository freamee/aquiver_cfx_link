local AttachmentManager = require("runtime.client.attachment_manager")
local AttachmentAPI = require("runtime.client.attachment_api")

local attachments = AttachmentManager:new()
local api = AttachmentAPI:new(attachments)

exports("createAttachment", function(id, definition)
    local ownerResource = GetInvokingResource() or GetCurrentResourceName()
    return api:createAttachment(id, definition, ownerResource)
end)

local methods = {
    "getAttachment",
    "getAttachmentEntity",
    "destroyAttachment",
    "setAttachmentOffset",
    "addAttachmentSound",
    "removeAttachmentSound",
    "addAttachmentParticle",
    "removeAttachmentParticle",
    "setAttachmentParticleOffset",
}

for _, method in ipairs(methods) do
    exports(method, function(...)
        return api[method](api, ...)
    end)
end

RegisterNetEvent("aquiver::attachments::update", function(targetSource, id, definition, revision)
    attachments:update(targetSource, id, definition, revision)
end)

RegisterNetEvent("aquiver::attachments::delete", function(targetSource, id, revision)
    attachments:delete(targetSource, id, revision)
end)

RegisterNetEvent("aquiver::attachments::snapshot", function(state, revision)
    attachments:snapshot(state, revision)
end)

Citizen.CreateThread(function()
    TriggerServerEvent("aquiver::attachments::requestSync")

    while true do
        attachments:reconcile()
        Citizen.Wait(500)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        attachments:destroy()
    end
end)
