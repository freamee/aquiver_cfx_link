local Entity = require("client.classes.Entity")
local lerp = require("shared.lerp")

---@class C_Prop : Entity
---@field private _moving boolean
local Prop = lib.class("C_Prop", Entity)

---@param modelHash string | number
---@param position vector3
---@param rotation vector3
function Prop:constructor(modelHash, position, rotation)
    self:super(
        CreateObjectNoOffset(
            modelHash,
            position.x,
            position.y,
            position.z,
            false,
            false,
            false
        )
    )
    self:setRotation(rotation)
    self._moving = false
end

---@param variation number
function Prop:setTextureVariation(variation)
    SetObjectTextureVariation(self._entity, variation)
end

function Prop:getTextureVariation()
    return GetObjectTextureVariation(self._entity)
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

return Prop
