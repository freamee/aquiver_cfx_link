local Cursor = require("runtime.client.cursor.index")

RegisterCommand("TOGGLE_CURSOR_STATE", function()
    Cursor:toggle()
end, false)

RegisterKeyMapping("TOGGLE_CURSOR_STATE", "Cursor", "keyboard", "m")

exports("SetCursor", function(...)
    return Cursor:set(...)
end)

exports("GetCursor", function()
    return Cursor:get()
end)

exports("ForceCursor", function(...)
    return Cursor:force(...)
end)

-- local AttachmentManager = require("runtime.client.attachment_manager")
-- local AttachmentAPI = require("runtime.client.attachment_api")

-- local attachments = AttachmentManager:new()
-- local api = AttachmentAPI:new(attachments)

-- exports("createAttachment", function(id, definition)
--     local ownerResource = GetInvokingResource() or GetCurrentResourceName()
--     return api:createAttachment(id, definition, ownerResource)
-- end)


-- RegisterNetEvent("aquiver::attachments::update", function(targetSource, id, definition, revision)
--     attachments:update(targetSource, id, definition, revision)
-- end)

-- RegisterNetEvent("aquiver::attachments::delete", function(targetSource, id, revision)
--     attachments:delete(targetSource, id, revision)
-- end)

-- RegisterNetEvent("aquiver::attachments::snapshot", function(state, revision)
--     attachments:snapshot(state, revision)
-- end)

-- Citizen.CreateThread(function()
--     TriggerServerEvent("aquiver::attachments::requestSync")

--     while true do
--         attachments:reconcile()
--         Citizen.Wait(500)
--     end
-- end)

-- AddEventHandler("onResourceStop", function(resourceName)
--     if resourceName == GetCurrentResourceName() then
--         attachments:destroy()
--     end
-- end)
