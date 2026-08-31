local Entity = require("server.classes.Entity")

---@class S_Cfx_Prop : S_Cfx_Entity
local Prop = lib.class("S_Cfx_Prop", Entity)

---@param modelHash string
---@param position vector3
---@param rotation vector3
function Prop:constructor(modelHash, position, rotation)
    self:super(
        CreateObject(
            modelHash,
            position.x,
            position.y,
            position.z,
            true,
            true,
            false
        )
    )

    self:setRotation(rotation)
end

return Prop
