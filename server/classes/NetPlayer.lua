---@class NetPlayer : OxClass
---@field private _playerSource number
---@field private _state StateBag
local NetPlayer = lib.class("NetPlayer")

---@param playerSource number
function NetPlayer.FromSource(playerSource)
    return NetPlayer:new(playerSource)
end

---@param playerSource number
function NetPlayer:constructor(playerSource)
    self._playerSource = playerSource
    self._state = Player(playerSource).state
end

function NetPlayer:getStateBag()
    return self._state
end

function NetPlayer:getSource()
    return self._playerSource
end

function NetPlayer:getSourceStr()
    return tostring(self._playerSource)
end

function NetPlayer:exists()
    return DoesPlayerExist(self:getSourceStr())
end

function NetPlayer:getNetId()
    return NetworkGetNetworkIdFromEntity(self:getPed())
end

function NetPlayer:getPed()
    return GetPlayerPed(self:getSource())
end

function NetPlayer:getRoutingBucket()
    return GetPlayerRoutingBucket(self:getSourceStr())
end

---@param bucket number
function NetPlayer:setRoutingBucket(bucket)
    SetPlayerRoutingBucket(self:getSourceStr(), bucket)
end

function NetPlayer:getHeading()
    return GetEntityHeading(self:getPed())
end

---@param heading number
function NetPlayer:setHeading(heading)
    SetEntityHeading(self:getPed(), heading)
end

function NetPlayer:getPosition()
    return GetEntityCoords(self:getPed())
end

---@param position vector3
function NetPlayer:setPosition(position)
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
function NetPlayer:setPositionNoOffset(position)
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

return NetPlayer
