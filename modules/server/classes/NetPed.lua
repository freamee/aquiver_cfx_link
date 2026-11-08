local NetEntity = require("server.classes.NetEntity")

---@class NetPed : NetEntity
local NetPed = lib.class("NetPed", NetEntity)

---@param modelHash string
---@param quaternion vector4
function NetPed.Create(modelHash, quaternion)
    local id = CreatePed(
        2,
        modelHash,
        quaternion.x,
        quaternion.y,
        quaternion.z,
        quaternion.w,
        true,
        true
    )

    return NetPed:new(id)
end

---@param entity number
function NetPed:constructor(entity)
    self:super(entity)
end

return NetPed
