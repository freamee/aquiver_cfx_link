local Element = require("runtime.server.attachment.element")

---@class S_ElementSound : S_Element
---@field private _audioName string
---@field private _audioRef string
local ElementSound = lib.class("S_ElementSound", Element)

---@param id string
---@param audioName string
---@param audioRef string
function ElementSound:constructor(id, audioName, audioRef)
    self:super(id)

    self._audioName = audioName
    self._audioRef = audioRef
end

function ElementSound:toDefinition()
    if self:isDestroyed() then
        return nil
    end

    return {
        id = self:getId(),
        audioName = self._audioName,
        audioRef = self._audioRef,
    }
end

---@param targetSource number
---@param attachment S_ElementProp
function ElementSound:attach(targetSource, attachment)
    targetSource = tonumber(targetSource)
    local attachmentSource = attachment:getTargetSource()

    if attachmentSource and attachmentSource ~= targetSource then
        return false
    end

    return attachment:addSound(self)
end

function ElementSound:destroy()
    if self:isDestroyed() then
        return false
    end

    local attachment = self:getAttachment()

    if attachment then
        attachment:removeSound(self:getId())
    end

    return Element.destroy(self)
end

return ElementSound
