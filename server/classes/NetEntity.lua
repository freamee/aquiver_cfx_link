---@class NetEntity : OxClass
---@field private _entity number
---@field private _state StateBag
local NetEntity = lib.class("NetEntity")

---@param entity number
function NetEntity:constructor(entity)
    self._entity = entity
    self._state = Entity(self._entity).state
end

function NetEntity:getScriptId()
    return self._entity
end

function NetEntity:getRoutingBucket()
    return GetEntityRoutingBucket(self._entity)
end

---@param bucket number
function NetEntity:setRoutingBucket(bucket)
    SetEntityRoutingBucket(self._entity, bucket)
end

function NetEntity:getNetId()
    return NetworkGetNetworkIdFromEntity(self._entity)
end

function NetEntity:exists()
    return DoesEntityExist(self._entity)
end

function NetEntity:getStatebag()
    return self._state
end

function NetEntity:getRotation()
    return GetEntityRotation(self._entity)
end

---@param rotation vector3
function NetEntity:setRotation(rotation)
    SetEntityRotation(self._entity, rotation.x, rotation.y, rotation.z, 2, false)
end

function NetEntity:getPosition()
    return GetEntityCoords(self._entity)
end

---@param position vector3
function NetEntity:setPosition(position)
    SetEntityCoords(self._entity, position.x, position.y, position.z, false, false, false, false)
end

---@param position vector3
function NetEntity:setPositionNoOffset(position)
    SetEntityCoordsNoOffset(
        self._entity,
        position.x,
        position.y,
        position.z,
        false,
        false,
        false
    )
end

return NetEntity
