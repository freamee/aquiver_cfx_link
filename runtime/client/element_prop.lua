local Element = require("runtime.client.element")

---@class C_ElementProp : C_Element
---@field private _modelHash string|number
---@field private _entity number?
---@field private _particles table<string, C_ElementParticle>
---@field private _particleStarts table<string, table>
---@field private _sounds table<string, C_ElementSound>
local ElementProp = lib.class("C_ElementProp", Element)

---@param id string
---@param modelHash string|number
---@param shouldCancel? fun(): boolean
function ElementProp:constructor(id, modelHash, shouldCancel)
    self:super(id)

    self._modelHash = modelHash
    self._particles = {}
    self._particleStarts = {}
    self._sounds = {}

    if self:isDestroyed() or (shouldCancel and shouldCancel()) then
        self:destroy()
        return
    end

    -- Model loading can yield and throw, so a failed constructor must unregister itself.
    local loaded, model = pcall(lib.requestModel, modelHash, 10000)
    if not loaded then
        self:destroy()
        error(model, 2)
    end

    if self:isDestroyed() or (shouldCancel and shouldCancel()) then
        SetModelAsNoLongerNeeded(model)
        self:destroy()
        return
    end

    self._entity = CreateObject(
        model,
        0,
        0,
        0,
        false,
        false,
        false
    )
    SetModelAsNoLongerNeeded(model)

    if not self._entity or self._entity == 0 or not DoesEntityExist(self._entity) then
        self:destroy()
        error(("Failed to create attachment '%s'"):format(id), 2)
    end
end

function ElementProp:getScriptId()
    return self._entity
end

---@param id string
---@return C_ElementParticle?
function ElementProp:getParticle(id)
    return self._particles[id]
end

---@param id string
---@return C_ElementSound?
function ElementProp:getSound(id)
    return self._sounds[id]
end

---@param element C_ElementProp
---@param position vector3
---@param rotation vector3
function ElementProp:attachElement(element, position, rotation)
    return element:attach(
        self:getScriptId(),
        position,
        rotation,
        -1
    )
end

---@param to number
---@param position vector3
---@param rotation vector3
---@param boneIndex? number Ped bone ID when attaching to a ped.
---@param collision? boolean
---@return boolean
function ElementProp:attach(to, position, rotation, boneIndex, collision)
    if self:isDestroyed() then
        return false
    end

    if not self._entity or not DoesEntityExist(self._entity) then
        return false
    end

    if not to or to == 0 or not DoesEntityExist(to) then
        return false
    end

    position = position or vector3(0, 0, 0)
    rotation = rotation or vector3(0, 0, 0)
    boneIndex = boneIndex or -1
    if IsEntityAPed(to) and boneIndex ~= -1 then
        boneIndex = GetPedBoneIndex(to, boneIndex)
    end

    AttachEntityToEntity(
        self._entity,
        to,
        boneIndex,
        position.x,
        position.y,
        position.z,
        rotation.x,
        rotation.y,
        rotation.z,
        false,
        false,
        collision or false,
        false,
        1,
        true
    )

    return true
end

---@param particle C_ElementParticle
---@param position vector3
---@param rotation vector3
---@param scale? number
---@return C_ElementParticle?
function ElementProp:addParticle(particle, position, rotation, scale)
    local attachment = particle:getAttachment()
    if attachment and attachment ~= self and not attachment:isDestroyed() then
        return
    end

    if self:isDestroyed() then
        particle:destroy()
        return
    end

    local id = particle:getId()
    local previous = self._particles[id]
    if previous and previous ~= particle then
        previous:setAttachment(nil)
        previous:destroy()
    end

    -- Record ownership before startOn yields, and keep track of this specific add.
    local start = {}
    self._particleStarts[id] = start
    self._particles[id] = particle
    particle:setAttachment(self)

    local started = particle:startOn(self, position, rotation, scale)
    if self._particleStarts[id] ~= start then
        return
    end

    self._particleStarts[id] = nil
    if started then
        return particle
    end

    if self._particles[id] == particle then
        self._particles[id] = nil
        particle:setAttachment(nil)
    end

    particle:destroy()
end

---@param sound C_ElementSound
---@return C_ElementSound?
function ElementProp:addSound(sound)
    local attachment = sound:getAttachment()
    if attachment and attachment ~= self and not attachment:isDestroyed() then
        return
    end

    if self:isDestroyed() then
        sound:destroy()
        return
    end

    local id = sound:getId()
    local previous = self._sounds[id]
    if previous and previous ~= sound then
        previous:setAttachment(nil)
        previous:destroy()
    end

    self._sounds[id] = sound
    sound:setAttachment(self)

    if sound:attach(self) then
        return sound
    end

    self._sounds[id] = nil
    sound:setAttachment(nil)
    sound:destroy()
end

---@param id string
function ElementProp:removeParticle(id)
    self._particleStarts[id] = nil

    local particle = self._particles[id]
    if not particle then
        return
    end

    self._particles[id] = nil
    particle:setAttachment(nil)
    particle:destroy()
end

---@param id string
function ElementProp:removeSound(id)
    local sound = self._sounds[id]
    if not sound then
        return
    end

    self._sounds[id] = nil
    sound:setAttachment(nil)
    sound:destroy()
end

function ElementProp:destroy()
    if self:isDestroyed() then
        return
    end

    Element.destroy(self)
    self._particleStarts = {}

    for _, sound in pairs(self._sounds) do
        sound:setAttachment(nil)
        sound:destroy()
    end

    for _, particle in pairs(self._particles) do
        particle:setAttachment(nil)
        particle:destroy()
    end

    self._sounds = {}
    self._particles = {}

    if self._entity and DoesEntityExist(self._entity) then
        DeleteObject(self._entity)
    end

    self._entity = nil
end

return ElementProp
