local AttachmentRegistry = require("runtime.server.attachment.attachment_registry")

AddEventHandler("playerDropped", function()
    AttachmentRegistry:onPlayerQuit(source)
end)
AddEventHandler("onResourceStop", function(...)
    AttachmentRegistry:onResourceStop(...)
end)
