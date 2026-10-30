---@class C_Attachment : OxClass
---@field private _targetSource number
local Attachment = lib.class("C_Attachment")

---@param targetSource number
---@param id string
function Attachment:constructor(targetSource, id)
    self:super(id)

    self._targetSource = targetSource
end

return Attachment
