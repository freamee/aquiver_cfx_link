local Entity = require("client.classes.Entity")

---@class C_Vehicle : Entity
local Vehicle = lib.class("C_Vehicle", Entity)

---@param entity number
function Vehicle:constructor(entity)
    self:super(entity)
end

return Vehicle
