local Entity = require("server.classes.Entity")

---@class S_Cfx_Ped : S_Cfx_Entity
local Ped = lib.class("S_Cfx_Ped", Entity)

---@param modelHash string
---@param quaternion vector4
function Ped:constructor(modelHash, quaternion)
    self:super(
        CreatePed(
            2,
            modelHash,
            quaternion.x,
            quaternion.y,
            quaternion.z,
            quaternion.w,
            true,
            true
        )
    )
end

return Ped
