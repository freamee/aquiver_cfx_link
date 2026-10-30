---@class S_Attachment : OxClass
---@field private _targetSource number
local Attachment = lib.class("S_Attachment")

---@param targetSource number
---@param id string
function Attachment:constructor(targetSource, id)
    self:super(id)

    self._targetSource = id
end

return Attachment
