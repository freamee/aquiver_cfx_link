local Element = require("runtime.client.element")
local ElementProp = require("runtime.client.element_prop")
local ElementParticle = require("runtime.client.element_particle")
local ElementSound = require("runtime.client.element_sound")

local function normalizeDefinition(definition)
    definition = lib.table.deepclone(definition)
    definition.position = definition.position or definition.offsetPosition or vector3(0, 0, 0)
    definition.rotation = definition.rotation or definition.offsetRotation or vector3(0, 0, 0)
    definition.boneIndex = definition.boneIndex or -1
    definition.collision = definition.collision or false
    definition.particles = definition.particles or {}
    definition.sounds = definition.sounds or {}

    for _, particle in pairs(definition.particles) do
        particle.position = particle.position or particle.offsetPosition or vector3(0, 0, 0)
        particle.rotation = particle.rotation or particle.offsetRotation or vector3(0, 0, 0)
        particle.scale = particle.scale or 1.0
    end

    return definition
end

---@class C_Attachment : C_Element
---@field private _targetSource number
---@field private _definition table
---@field private _element C_ElementProp?
---@field private _ped number?
---@field private _loading boolean
---@field private _loadVersion number
---@field private _retryAt number
---@field private _particleStates table<string, table>
---@field private _soundStates table<string, table>
local Attachment = lib.class("C_Attachment", Element)

---@param targetSource number
---@param id string
---@param definition table
function Attachment:constructor(targetSource, id, definition)
    self:super(id)

    self._targetSource = targetSource
    self._definition = normalizeDefinition(definition)
    self._element = nil
    self._ped = nil
    self._loading = false
    self._loadVersion = 0
    self._retryAt = 0
    self._particleStates = {}
    self._soundStates = {}
end

function Attachment:getTargetSource()
    return self._targetSource
end

function Attachment:getDefinition()
    return lib.table.deepclone(self._definition)
end

function Attachment:getScriptId()
    if not self._element then
        return
    end

    local entity = self._element:getScriptId()
    if entity and DoesEntityExist(entity) then
        return entity
    end
end

-- Only a different model needs a new prop. Effects are updated separately.
function Attachment:updateDefinition(definition)
    definition = normalizeDefinition(definition)
    local current = self._definition

    if current.modelHash ~= definition.modelHash then
        return false
    end

    local offsetChanged = current.boneIndex ~= definition.boneIndex
        or current.collision ~= definition.collision
        or not lib.table.matches(current.position, definition.position)
        or not lib.table.matches(current.rotation, definition.rotation)

    -- A model-loading thread may already be using this definition table.
    current.position = definition.position
    current.rotation = definition.rotation
    current.boneIndex = definition.boneIndex
    current.collision = definition.collision
    current.particles = definition.particles or {}
    current.sounds = definition.sounds or {}

    if self._element then
        if offsetChanged then
            self._element:attach(
                self._ped,
                current.position,
                current.rotation,
                current.boneIndex,
                current.collision
            )
        end

        self:syncEffects()
    end

    return true
end

function Attachment:effectFailed(kind, id, state, message)
    state.retryAt = GetGameTimer() + 5000

    if not state.failureLogged then
        state.failureLogged = true
        print(("[aquiver_cfx] Attachment %s/%s %s '%s' failed: %s"):format(
            self._targetSource,
            self:getId(),
            kind,
            id,
            message
        ))
    end
end

function Attachment:syncSounds()
    local element = self._element
    local sounds = self._definition.sounds or {}

    for id, state in pairs(self._soundStates) do
        if not sounds[id] or not lib.table.matches(state.definition, sounds[id]) then
            element:removeSound(id)
            self._soundStates[id] = nil
        end
    end

    for id, data in pairs(sounds) do
        local state = self._soundStates[id]

        if not state then
            state = { definition = data, retryAt = 0 }
            self._soundStates[id] = state
        end

        if state.effect and state.effect:isDestroyed() then
            state.effect = nil
        end

        if not state.effect and GetGameTimer() >= state.retryAt then
            local sound = ElementSound:new(id, data.audioName, data.audioRef)
            local success, result = pcall(element.addSound, element, sound)

            if success and result then
                state.effect = sound
            else
                if element:getSound(id) == sound then
                    element:removeSound(id)
                else
                    sound:destroy()
                end

                self:effectFailed("sound", id, state, result or "could not start")
            end
        end
    end
end

function Attachment:startParticle(id, state)
    local element = self._element
    state.loading = true

    Citizen.CreateThread(function()
        if self._element ~= element or self._particleStates[id] ~= state then
            return
        end

        local data = state.definition
        local particle = ElementParticle:new(id, data.dictionary, data.name)
        state.effect = particle
        local success, result = pcall(
            element.addParticle,
            element,
            particle,
            data.position,
            data.rotation,
            data.scale
        )

        if self._element ~= element or self._particleStates[id] ~= state then
            particle:destroy()
            return
        end

        state.loading = false

        if success and result then
            return
        end

        state.effect = nil

        if element:getParticle(id) == particle then
            element:removeParticle(id)
        else
            particle:destroy()
        end

        self:effectFailed("particle", id, state, result or "could not start")
    end)
end

function Attachment:syncParticles()
    local element = self._element
    local particles = self._definition.particles or {}

    for id, state in pairs(self._particleStates) do
        local data = particles[id]
        if not data or state.definition.dictionary ~= data.dictionary or state.definition.name ~= data.name then
            element:removeParticle(id)
            self._particleStates[id] = nil
        elseif not lib.table.matches(state.definition, data) then
            state.definition = data
            if state.effect then
                state.effect:setOffset(data.position, data.rotation, data.scale)
            end
        end
    end

    for id, data in pairs(particles) do
        local state = self._particleStates[id]

        if not state then
            state = { definition = data, retryAt = 0 }
            self._particleStates[id] = state
        end

        if state.effect and state.effect:isDestroyed() then
            state.effect = nil
        end

        if not state.effect and not state.loading and GetGameTimer() >= state.retryAt then
            self:startParticle(id, state)
        end
    end
end

function Attachment:syncEffects()
    self:syncSounds()
    self:syncParticles()
end

function Attachment:getPlayerPed()
    local playerId = GetPlayerFromServerId(self._targetSource)
    if playerId == -1 then
        return
    end

    local ped = GetPlayerPed(playerId)
    if ped ~= 0 and DoesEntityExist(ped) then
        return ped
    end
end

function Attachment:isLoadCancelled(version, ped)
    if self:isDestroyed() or self._loadVersion ~= version then
        return true
    end

    return self:getPlayerPed() ~= ped
end

function Attachment:createElement(ped, version)
    local definition = self._definition
    local element = ElementProp:new(self:getId(), definition.modelHash, function()
        return self:isLoadCancelled(version, ped)
    end)

    if self:isLoadCancelled(version, ped) then
        element:destroy()
        return
    end

    self._element = element

    local attached = element:attach(
        ped,
        definition.position,
        definition.rotation,
        definition.boneIndex,
        definition.collision
    )

    if not attached then
        self:despawn()
        return
    end

    self:syncEffects()
end

function Attachment:spawn(ped)
    self._ped = ped
    self._loading = true
    self._loadVersion = self._loadVersion + 1

    local version = self._loadVersion

    Citizen.CreateThread(function()
        local success, message = pcall(self.createElement, self, ped, version)

        if self._loadVersion ~= version then
            return
        end

        self._loading = false

        if not success then
            self:despawn()
            self._retryAt = GetGameTimer() + 5000

            if not self._failureLogged then
                self._failureLogged = true
                print(("[aquiver_cfx] Attachment %s/%s failed: %s"):format(
                    self._targetSource,
                    self:getId(),
                    message
                ))
            end

            return
        end

        if self:isLoadCancelled(version, ped) then
            self:despawn()
        end
    end)
end

function Attachment:despawn()
    self._loadVersion = self._loadVersion + 1
    self._loading = false
    self._ped = nil

    if self._element then
        self._element:destroy()
        self._element = nil
    end

    self._particleStates = {}
    self._soundStates = {}
end

function Attachment:update()
    if self:isDestroyed() then
        return
    end

    local ped = self:getPlayerPed()
    if not ped then
        if self._ped then
            self:despawn()
        end

        return
    end

    if self._ped and self._ped ~= ped then
        self:despawn()
    end

    if self._element then
        local entity = self._element:getScriptId()

        if self._element:isDestroyed() or not entity or not DoesEntityExist(entity) then
            self:despawn()
        else
            self:syncEffects()
        end
    end

    if self._element or self._loading or GetGameTimer() < self._retryAt then
        return
    end

    self:spawn(ped)
end

function Attachment:destroy()
    if self:isDestroyed() then
        return
    end

    Element.destroy(self)
    self:despawn()
end

return Attachment
