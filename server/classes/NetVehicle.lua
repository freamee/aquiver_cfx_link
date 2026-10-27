local NetEntity = require("server.classes.NetEntity")
local Color = require("shared.Color")

---@class NetVehicle : NetEntity
local NetVehicle = lib.class("NetVehicle", NetEntity)

---@param modelHash string
---@param position vector3
---@param rotation vector3
function NetVehicle.Create(modelHash, position, rotation)
    local id = CreateVehicleServerSetter(
        modelHash,
        "automobile",
        position.x,
        position.y,
        position.z,
        rotation.z
    )

    return NetVehicle:new(id)
end

---@param entity number
function NetVehicle:constructor(entity)
    self:super(entity)
end

---@param plateText string
function NetVehicle:setNumberPlateText(plateText)
    SetVehicleNumberPlateText(self:getScriptId(), plateText)
end

function NetVehicle:getNumberPlateText()
    return GetVehicleNumberPlateText(self:getScriptId())
end

---@param primary number
---@param secondary number
function NetVehicle:setColor(primary, secondary)
    SetVehicleColours(self:getScriptId(), primary, secondary)
end

---@return integer primary
---@return integer secondary
function NetVehicle:getColor()
    local primary, secondary = GetVehicleColours(self:getScriptId())

    return primary, secondary
end

function NetVehicle:getColorPrimary()
    local r, g, b = GetVehicleCustomPrimaryColour(self:getScriptId())

    return Color:new(r, g, b)
end

---@param color Color
function NetVehicle:setColorPrimary(color)
    SetVehicleCustomPrimaryColour(self:getScriptId(), color:getR(), color:getG(), color:getB())
end

function NetVehicle:getColorSecondary()
    local r, g, b = GetVehicleCustomSecondaryColour(self:getScriptId())

    return Color:new(r, g, b)
end

---@param color Color
function NetVehicle:setColorSecondary(color)
    SetVehicleCustomSecondaryColour(self:getScriptId(), color:getR(), color:getG(), color:getB())
end

return NetVehicle
