---@class C_Ped : OxClass
---@field private _entity number
local Ped = lib.class("C_Ped")

---@param modelHash string
---@param quaternion vector4
function Ped:constructor(modelHash, quaternion)
    self._entity = CreatePed(
        1,
        modelHash,
        quaternion.x,
        quaternion.y,
        quaternion.z,
        quaternion.w,
        false,
        false
    )
end

function Ped:getFreezeState()
    return IsEntityFrozen(self._entity)
end

---@param newState boolean
function Ped:setFreezeState(newState)
    FreezeEntityPosition(self._entity, newState)
end

return Ped
