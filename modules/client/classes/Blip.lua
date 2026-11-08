---@class C_Blip : OxClass
---@field private _name string
---@field private _entity number
local Blip = lib.class("C_Blip")

---@param position vector3
function Blip:constructor(name, position)
    self._name = name
    self._entity = AddBlipForCoord(position.x, position.y, position.z)
end

---@param display number
function Blip:setDisplay(display)
    SetBlipDisplay(self._entity, display)
end

function Blip:getDisplay()
    return GetBlipInfoIdDisplay(self._entity)
end

---@param category number
function Blip:setCategory(category)
    SetBlipCategory(self._entity, category)
end

---@param newState boolean
function Blip:setShortRangeState(newState)
    SetBlipAsShortRange(self._entity, newState)
end

function Blip:getShortRangeState()
    return IsBlipShortRange(self._entity)
end

---@param position vector3
function Blip:setPosition(position)
    SetBlipCoords(self._entity, position.x, position.y, position.z)
end

function Blip:getPosition()
    return GetBlipCoords(self._entity)
end

---@param sprite number
function Blip:setSprite(sprite)
    SetBlipSprite(self._entity, sprite)

    -- Has to re-set the name after changing the sprite.

    self:setName(self:getName())
end

function Blip:getSprite()
    return GetBlipSprite(self._entity)
end

---@param color number
function Blip:setColor(color)
    SetBlipColour(self._entity, color)
end

function Blip:getColor()
    return GetBlipColour(self._entity)
end

---@param scale number
function Blip:setScale(scale)
    SetBlipScale(self._entity, scale)
end

function Blip:getName()
    return self._name
end

---@param newName string
function Blip:setName(newName)
    self._name = newName

    AddTextEntry('MY_BLIP', self._name)
    BeginTextCommandSetBlipName('MY_BLIP')
    EndTextCommandSetBlipName(self._entity)
end

function Blip:destroy()
    RemoveBlip(self._entity)
end

return Blip
