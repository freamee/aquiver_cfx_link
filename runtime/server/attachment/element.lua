---@class S_Element : OxClass
---@field private _id string
---@field private _destroyed boolean
local Element = lib.class("S_Element")

---@param id string
function Element:constructor(id)
    self._id = id
    self._destroyed = false
end

function Element:getId()
    return self._id
end

function Element:isDestroyed()
    return self._destroyed
end

return Element
