local NetEntity = require("server.classes.NetEntity")

---@class NetProp : NetEntity
local NetProp = lib.class("NetProp", NetEntity)

---@param modelHash string
---@param position vector3
---@param rotation vector3
function NetProp.Create(modelHash, position, rotation)
    local id = CreateObject(
        modelHash,
        position.x,
        position.y,
        position.z,
        true,
        true,
        false
    )

    return NetProp:new(id)
end

---@param entity number
function NetProp:constructor(entity)
    self:super(entity)
end

return NetProp
