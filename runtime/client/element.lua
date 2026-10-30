local Registry = require("lua.client.ElementRegistry")

---@class C_Element : OxClass
---@field private _id string
---@field private _attachment C_ElementProp?
---@field protected _destroyed boolean
local Element = lib.class("C_Element")

---@param id string
function Element:constructor(id)
    self._id = id
    self._destroyed = not Registry.add(self)
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

---@param attachment C_ElementProp?
function Element:setAttachment(attachment)
    self._attachment = attachment
end

function Element:destroy()
    if self._destroyed then
        return
    end

    self._destroyed = true

    Registry.remove(self)
end

return Element
