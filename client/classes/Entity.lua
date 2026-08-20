---@class Entity : OxClass
---@field protected _entity number
local Entity = lib.class("Entity")

---@param entity number
function Entity:constructor(entity)
    self._entity = entity
end

function Entity:getScriptId()
    return self._entity
end

---@param offsetPosition vector3
function Entity:getOffsetPosition(offsetPosition)
    return GetOffsetFromEntityInWorldCoords(self._entity, offsetPosition.x, offsetPosition.y, offsetPosition.z)
end

function Entity:getFreezeState()
    return IsEntityFrozen(self._entity)
end

---@param newState boolean
function Entity:setFreezeState(newState)
    FreezeEntityPosition(self._entity, newState)
end

function Entity:getCollisionState()
    return GetEntityCollisionDisabled(self._entity)
end

---@param newState boolean
---@param keepPhysics boolean
function Entity:setCollisionState(newState, keepPhysics)
    SetEntityCollision(self._entity, newState, keepPhysics)
end

function Entity:getRotation()
    return GetEntityRotation(self._entity)
end

---@param rotation vector3
function Entity:setRotation(rotation)
    SetEntityRotation(self._entity, rotation.x, rotation.y, rotation.z, 2, false)
end

function Entity:getPosition()
    return GetEntityCoords(self._entity)
end

---@param position vector3
function Entity:setPosition(position)
    SetEntityCoords(self._entity, position.x, position.y, position.z, false, false, false, false)
end

---@param newState boolean
function Entity:setVisibleState(newState)
    SetEntityVisible(self._entity, newState, newState)
end

function Entity:getVisibleState()
    return IsEntityVisible(self._entity)
end

---@param to Entity
---@param boneIndex number
---@param offsetPosition vector3
---@param offsetRotation vector3
---@param collision boolean
function Entity:attach(to, boneIndex, offsetPosition, offsetRotation, collision)
    AttachEntityToEntity(
        self._entity,
        to:getScriptId(),
        boneIndex,
        offsetPosition.x,
        offsetPosition.y,
        offsetPosition.z,
        offsetRotation.x,
        offsetRotation.y,
        offsetRotation.z,
        false,
        false,
        collision,
        false,
        2,
        true
    )
end

function Entity:detach()
    DetachEntity(self._entity, true, true)
end

function Entity:destroy()
    DeleteEntity(self._entity)
end

return Entity
