local lerp = require("lua.shared.lerp")

---@class C_Prop : OxClass
---@field private _entity number
---@field private _moving boolean
local Prop = lib.class("C_Prop")

---@param modelHash string | number
---@param position vector3
---@param rotation vector3
function Prop:constructor(modelHash, position, rotation)
    self._entity = CreateObjectNoOffset(
        modelHash,
        position.x,
        position.y,
        position.z,
        false,
        false,
        false
    )
    self:setRotation(rotation)
    self._moving = false
end

function Prop:getScriptId()
    return self._entity
end

---@param offsetPosition vector3
function Prop:getOffsetPosition(offsetPosition)
    return GetOffsetFromEntityInWorldCoords(self._entity, offsetPosition.x, offsetPosition.y, offsetPosition.z)
end

function Prop:getFreezeState()
    return IsEntityPositionFrozen(self._entity)
end

---@param newState boolean
function Prop:setFreezeState(newState)
    FreezeEntityPosition(self._entity, newState)
end

function Prop:getCollisionState()
    return GetEntityCollisionDisabled(self._entity)
end

---@param newState boolean
---@param keepPhysics boolean
function Prop:setCollisionState(newState, keepPhysics)
    SetEntityCollision(self._entity, newState, keepPhysics)
end

function Prop:getRotation()
    return GetEntityRotation(self._entity)
end

---@param rotation vector3
function Prop:setRotation(rotation)
    SetEntityRotation(self._entity, rotation.x, rotation.y, rotation.z, 2, false)
end

function Prop:getPosition()
    return GetEntityCoords(self._entity)
end

---@param position vector3
function Prop:setPosition(position)
    SetEntityCoords(self._entity, position.x, position.y, position.z, false, false, false, false)
end

function Prop:getTextureVariation()
    return GetObjectTextureVariation(self._entity)
end

---@param texture number
function Prop:setTextureVariation(texture)
    SetObjectTextureVariation(self._entity, texture)
end

---@param newState boolean
function Prop:setVisibleState(newState)
    SetEntityVisible(self._entity, newState, newState)
end

function Prop:getVisibleState()
    return IsEntityVisible(self._entity)
end

---@param to C_Prop
---@param boneIndex number
---@param offsetPosition vector3
---@param offsetRotation vector3
---@param collision boolean
function Prop:attach(to, boneIndex, offsetPosition, offsetRotation, collision)
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

function Prop:detach()
    DetachEntity(self._entity, true, true)
end

function Prop:isMoving()
    return self._moving
end

function Prop:stopMoving()
    self._moving = false
end

---@param destination vector3
---@param duration number
function Prop:moveTo(destination, duration)
    local start = self:getPosition()
    local startedAt = GetGameTimer()

    self._moving = true

    Citizen.CreateThread(function()
        while self._moving do
            local t = (GetGameTimer() - startedAt) / duration

            if t >= 1.0 then
                self:setPosition(destination)
                break
            end

            -- Smoothstep easing
            local eased = t * t * (3.0 - 2.0 * t)

            local toX = lerp(start.x, destination.x, eased)
            local toY = lerp(start.y, destination.y, eased)
            local toZ = lerp(start.z, destination.z, eased)

            self:setPosition(
                vector3(toX, toY, toZ)
            )

            Citizen.Wait(0)
        end
    end)
end

function Prop:destroy()
    DeleteObject(self._entity)
end

return Prop
