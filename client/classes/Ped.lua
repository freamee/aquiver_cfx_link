local Entity = require("client.classes.Entity")

---@class C_Ped : Entity
---@field private _entity number
local Ped = lib.class("C_Ped", Entity)

---@param modelHash string
---@param quaternion vector4
function Ped:constructor(modelHash, quaternion)
    self:super(
        CreatePed(
            1,
            modelHash,
            quaternion.x,
            quaternion.y,
            quaternion.z,
            quaternion.w,
            false,
            false
        )
    )
end

return Ped
