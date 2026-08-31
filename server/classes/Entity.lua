---@class S_Cfx_Entity : OxClass
---@field protected _entity number
---@field protected _state StateBag
local Actor = lib.class("S_Cfx_Entity")

---@param entity number
function Actor:constructor(entity)
    self._entity = entity
    self._state = Entity(self._entity).state
end

function Actor:getScriptId()
    return self._entity
end

function Actor:exists()
    return DoesEntityExist(self._entity)
end

function Actor:getStatebag()
    return self._state
end

function Actor:getRotation()
    return GetEntityRotation(self._entity)
end

---@param rotation vector3
function Actor:setRotation(rotation)
    SetEntityRotation(self._entity, rotation.x, rotation.y, rotation.z, 2, false)
end

function Actor:getPosition()
    return GetEntityCoords(self._entity)
end

---@param position vector3
function Actor:setPosition(position)
    SetEntityCoords(self._entity, position.x, position.y, position.z, false, false, false, false)
end

---@param position vector3
function Actor:setPositionNoOffset(position)
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

return Actor
