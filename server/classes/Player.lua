---@class S_Cfx_Player : OxClass
---@field private _playerSource number
---@field private _state StateBag
local APlayer = lib.class("S_Cfx_Player")

---@param playerSource number
function APlayer:constructor(playerSource)
    self._playerSource = playerSource
    self._state = Player(self._playerSource).state
end

function APlayer:getStatebag()
    return self._state
end

function APlayer:exists()
    return DoesPlayerExist(self:getSourceStr())
end

function APlayer:getNetId()
    return NetworkGetNetworkIdFromEntity(self:getPed())
end

function APlayer:getPed()
    return GetPlayerPed(self:getSource())
end

function APlayer:getHeading()
    return GetEntityHeading(self:getPed())
end

---@param heading number
function APlayer:setHeading(heading)
    SetEntityHeading(self:getPed(), heading)
end

function APlayer:getPosition()
    return GetEntityCoords(self:getPed())
end

---@param position vector3
function APlayer:setPosition(position)
    SetEntityCoords(
        self:getPed(),
        position.x,
        position.y,
        position.z,
        false,
        false,
        false,
        false
    )
end

---@param position vector3
function APlayer:setPositionNoOffset(position)
    SetEntityCoords(
        self:getPed(),
        position.x,
        position.y,
        position.z,
        false,
        false,
        false,
        false
    )
end

function APlayer:getSource()
    return self._playerSource
end

function APlayer:getSourceStr()
    return tostring(self._playerSource)
end

return APlayer
