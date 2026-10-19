local Entity = require("server.classes.Entity")

---@class S_Cfx_Vehicle : S_Cfx_Entity
---@field private _entity number
local Vehicle = lib.class("S_Cfx_Vehicle", Entity)

---@param modelHash string
---@param position vector3
---@param rotation vector3
function Vehicle:constructor(modelHash, position, rotation)
    self:super(
        CreateVehicleServerSetter(
            modelHash,
            "automobile",
            position.x,
            position.y,
            position.z,
            rotation.z
        )
    )

    self:setRotation(rotation)
end

return Vehicle
