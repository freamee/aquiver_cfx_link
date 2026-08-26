---@class C_Camera : OxClass
---@field private _entity number
local Camera = lib.class("C_Camera")

---@type C_Camera?
local activeCamera = nil
---@type C_Camera?
local interpCamera = nil

function Camera:constructor()
    self._entity = CreateCameraWithParams(
        "DEFAULT_SCRIPTED_CAMERA",
        0,
        0,
        0,
        0,
        0,
        0,
        60.0,
        false,
        2
    )
end

function Camera:getIsActive()
    return IsCamActive(self._entity)
end

---@param newState boolean
function Camera:setIsActive(newState)
    SetCamActive(self._entity, newState)
end

function Camera:getPosition()
    return GetCamCoord(self._entity)
end

---@param position vector3
function Camera:setPosition(position)
    SetCamCoord(self._entity, position.x, position.y, position.z)
end

function Camera:getRotation()
    return GetCamRot(self._entity, 2)
end

---@param rotation vector3
function Camera:setRotation(rotation)
    SetCamRot(self._entity, rotation.x, rotation.y, rotation.z, 2)
end

function Camera:getFov()
    return GetCamFov(self._entity)
end

---@param fov number
function Camera:setFov(fov)
    SetCamFov(self._entity, fov)
end

---@param target number
---@param offsetPosition vector3
function Camera:pointAtEntity(target, offsetPosition)
    PointCamAtEntity(self._entity, target, offsetPosition.x, offsetPosition.y, offsetPosition.z, true)
end

---@param position vector3
function Camera:pointAtPosition(position)
    PointCamAtCoord(self._entity, position.x, position.y, position.z)
end

function Camera:stopPointing()
    StopCamPointing(self._entity)
end

function Camera:isInterpolating()
    return IsCamInterpolating(self._entity)
end

---@param ease number
---@param focus boolean
function Camera:activate(ease, focus)
    self:setIsActive(true)

    local easing = ease and true or false

    RenderScriptCams(true, easing, ease, true, easing)

    activeCamera = self
end

---@param ease number
function Camera:deactivate(ease)
    self:setIsActive(false)

    if activeCamera == self then
        activeCamera = nil

        local easing = ease and true or false

        RenderScriptCams(false, easing, ease, false, easing)

        ClearFocus()
    end
end

---@param destination vector3
---@param rotation vector3
---@param ms number
---@param fov number
---@param easeLocation number
---@param easeRotation number
function Camera:moveTo(destination, rotation, ms, fov, easeLocation, easeRotation)
    if not interpCamera then
        interpCamera = Camera:new()
    end

    interpCamera:setPosition(self:getPosition())
    interpCamera:setRotation(self:getRotation())
    interpCamera:setFov(self:getFov())

    self:setPosition(destination)
    self:setRotation(rotation)
    self:setFov(fov)

    SetCamActiveWithInterp(
        self._entity,
        interpCamera._entity,
        ms,
        easeLocation,
        easeRotation
    )

    activeCamera = self
end

function Camera:detach()
    DetachCam(self._entity)
end

return Camera
