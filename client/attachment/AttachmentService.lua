local Attachment = require("client.attachment.Attachment")

local AttachmentService = {}

function AttachmentService:sync(data)
    local att = Attachment:new(data.id)
end

return AttachmentService
