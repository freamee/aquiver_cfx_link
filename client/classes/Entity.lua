---@class Entity : OxClass
---@field protected _entity number
---@field protected _state StateBag
local Actor = lib.class("Entity")

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

function Actor:getModelHash()
    return GetEntityModel(self._entity)
end

---@param modelHash string
function Actor:isModel(modelHash)
    return self:getModelHash() == GetHashKey(modelHash)
end

function Actor:activatePhysics()
    ActivatePhysics(self._entity)
end

function Actor:getStatebag()
    return self._state
end

---@param destination vector3
function Actor:distanceTo(destination)
    return #(self:getPosition() - destination)
end

---@param destination vector3
---@param range number
function Actor:isInRange(destination, range)
    return self:distanceTo(destination) <= range
end

---@param offsetPosition vector3
function Actor:getOffsetPosition(offsetPosition)
    return GetOffsetFromEntityInWorldCoords(self._entity, offsetPosition.x, offsetPosition.y, offsetPosition.z)
end

function Actor:getAlpha()
    return GetEntityAlpha(self._entity)
end

---@param alpha number
function Actor:setAlpha(alpha)
    SetEntityAlpha(self._entity, alpha, true)
end

function Actor:getFreezeState()
    return IsEntityPositionFrozen(self._entity)
end

---@param newState boolean
function Actor:setFreezeState(newState)
    FreezeEntityPosition(self._entity, newState)
end

function Actor:getCollisionState()
    return GetEntityCollisionDisabled(self._entity)
end

---@param newState boolean
---@param keepPhysics boolean
function Actor:setCollisionState(newState, keepPhysics)
    SetEntityCollision(self._entity, newState, keepPhysics)
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

---@param position vector3
function Actor:setPosition(position)
    SetEntityCoords(self._entity, position.x, position.y, position.z, false, false, false, false)
end

function Actor:getHeading()
    return GetEntityHeading(self._entity)
end

---@param heading number
function Actor:setHeading(heading)
    SetEntityHeading(self._entity, heading)
end

---@param newState boolean
function Actor:setVisibleState(newState)
    SetEntityVisible(self._entity, newState, newState)
end

function Actor:getVisibleState()
    return IsEntityVisible(self._entity)
end

---@param to Entity
---@param boneIndex number
---@param offsetPosition vector3
---@param offsetRotation vector3
---@param collision boolean
function Actor:attach(to, boneIndex, offsetPosition, offsetRotation, collision)
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

function Actor:detach()
    DetachEntity(self._entity, true, true)
end

function Actor:destroy()
    DeleteEntity(self._entity)
end

return Actor
