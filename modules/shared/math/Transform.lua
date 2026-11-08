---@class Transform : OxClass
---@field position vector3
---@field rotation vector3
local Transform = lib.class("Transform")

---@param position? vector3
---@param rotation? vector3
function Transform:constructor(position, rotation)
    self.position = position or vector3(0, 0, 0)
    self.rotation = rotation or vector3(0, 0, 0)
end

---@param entity number
function Transform.FromEntity(entity)
    return Transform:new(
        GetEntityCoords(entity),
        GetEntityRotation(entity)
    )
end

return Transform
