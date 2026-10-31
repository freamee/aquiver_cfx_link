---@class S_Element : OxClass
---@field private _id string
---@field private _destroyed boolean
---@field private _attachment S_ElementProp?
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

function Element:getAttachment()
    return self._attachment
end

---@param attachment S_ElementProp?
function Element:setAttachment(attachment)
    self._attachment = attachment
end

function Element:destroy()
    if self._destroyed then
        return false
    end

    self._destroyed = true
    self._attachment = nil

    return true
end

return Element
