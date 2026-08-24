---@class C_Particle : OxClass
---@field private _id number
---@field private _dictionary string
---@field private _name string
---@field private _started boolean
local Particle = lib.class("C_Particle")

---@param dictionary string
---@param name string
function Particle:constructor(dictionary, name)
    self._id = -1
    self._dictionary = dictionary
    self._name = name
end

function Particle:getId()
    return self._id
end

function Particle:isStarted()
    return self._started
end

---@param scale number
function Particle:setScale(scale)
    SetParticleFxLoopedScale(self._id, scale)
end

---@async
function Particle:request()
    RequestNamedPtfxAsset(self._dictionary)

    while not HasNamedPtfxAssetLoaded(self._dictionary) do
        Citizen.Wait(0)
    end
end

function Particle:stop()
    if not self._started then return end

    self._started = false

    StopParticleFxLooped(self._id, false)

    self._id = -1
end

---@param entity number
---@param offsetPosition vector3
---@param offsetRotation vector3
---@param scale number
function Particle:startOnEntity(entity, offsetPosition, offsetRotation, scale)
    if self._started then return end

    self._started = true

    self:request()

    UseParticleFxAsset(self._dictionary)

    self._id = StartParticleFxLoopedOnEntity(
        self._name,
        entity,
        offsetPosition.x,
        offsetPosition.y,
        offsetPosition.z,
        offsetRotation.x,
        offsetRotation.y,
        offsetRotation.z,
        scale,
        false,
        false,
        false
    )
end

---@param position vector3
---@param rotation vector3
---@param scale number
---@param isNetwork boolean
function Particle:startAtPosition(position, rotation, scale, isNetwork)
    if not self._started then return end

    self._started = true

    self:request()

    UseParticleFxAsset(self._dictionary)

    self._id = StartParticleFxLoopedAtCoord(
        self._name,
        position.x,
        position.y,
        position.z,
        rotation.x,
        rotation.y,
        rotation.z,
        scale,
        false,
        false,
        false,
        false
    )
end

---@param position vector3
---@param rotation vector3
---@param scale number
---@param isNetwork boolean
function Particle:startNonLoopedAtPosition(position, rotation, scale, isNetwork)
    self:request()

    UseParticleFxAsset(self._dictionary)

    if isNetwork then
        StartNetworkedParticleFxNonLoopedAtCoord(
            self._name,
            position.x,
            position.y,
            position.z,
            rotation.x,
            rotation.y,
            rotation.z,
            scale,
            false,
            false,
            false
        )
    else
        self._id = StartParticleFxNonLoopedAtCoord(
            self._name,
            position.x,
            position.y,
            position.z,
            rotation.x,
            rotation.y,
            rotation.z,
            scale,
            false,
            false,
            false
        )
    end
end

function Particle:destroy()
    StopParticleFxLooped(self._id, false)
end

return Particle
