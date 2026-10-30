local Element = require("runtime.client.element")

-- Keep a dictionary requested until all waiting particles have finished loading.
local assetUsers = {}

local function releaseAsset(dictionary)
    local remaining = assetUsers[dictionary] - 1

    if remaining > 0 then
        assetUsers[dictionary] = remaining
        return
    end

    assetUsers[dictionary] = nil

    RemoveNamedPtfxAsset(dictionary)
end

---@class C_ElementParticle : C_Element
---@field private _dictionary string
---@field private _name string
---@field private _handle number?
---@field private _generation number
---@field private _releaseAsset? fun()
local ElementParticle = lib.class("C_ElementParticle", Element)

---@param id string
---@param dictionary string
---@param name string
function ElementParticle:constructor(id, dictionary, name)
    self:super(id)

    self._dictionary = dictionary
    self._name = name
    self._generation = 0
end

function ElementParticle:getDictionary()
    return self._dictionary
end

function ElementParticle:getName()
    return self._name
end

function ElementParticle:_requestAsset()
    local dictionary = self._dictionary
    assetUsers[dictionary] = (assetUsers[dictionary] or 0) + 1

    -- Each start releases only its own request, even if a newer start is loading.
    local released = false
    local release

    release = function()
        if released then
            return
        end

        released = true
        if self._releaseAsset == release then
            self._releaseAsset = nil
        end

        releaseAsset(dictionary)
    end

    self._releaseAsset = release
    RequestNamedPtfxAsset(dictionary)

    return release
end

---@param element C_ElementProp
---@param position vector3
---@param rotation vector3
---@param scale? number
---@return boolean
function ElementParticle:startOn(element, position, rotation, scale)
    self:stop()

    if self:isDestroyed() or element:isDestroyed() then
        return false
    end

    local entity = element:getScriptId()
    if not entity or not DoesEntityExist(entity) then
        return false
    end

    local generation = self._generation

    local function cancelled()
        if self:isDestroyed() or self._generation ~= generation then
            return true
        end

        if element:isDestroyed() then
            return true
        end

        return not DoesEntityExist(entity)
    end

    local release = self:_requestAsset()
    local startedAt = GetGameTimer()

    while not HasNamedPtfxAssetLoaded(self._dictionary) do
        if cancelled() then
            release()
            return false
        end

        if GetGameTimer() - startedAt >= 10000 then
            release()
            error(("Timed out loading particle dictionary '%s'"):format(self._dictionary), 2)
        end

        Citizen.Wait(10)
    end

    if cancelled() then
        release()
        return false
    end

    UseParticleFxAsset(self._dictionary)

    self._handle = StartParticleFxLoopedOnEntity(
        self._name,
        entity,
        position.x,
        position.y,
        position.z,
        rotation.x,
        rotation.y,
        rotation.z,
        scale or 1.0,
        false,
        false,
        false
    )

    release()

    if not self._handle or self._handle == 0 then
        self._handle = nil
        error(("Failed to start particle '%s'"):format(self._name), 2)
    end

    return true
end

function ElementParticle:stop()
    self._generation = self._generation + 1

    if self._releaseAsset then
        self._releaseAsset()
    end

    if self._handle ~= nil then
        StopParticleFxLooped(self._handle, false)
        self._handle = nil
    end
end

function ElementParticle:destroy()
    if self:isDestroyed() then
        return
    end

    Element.destroy(self)

    self:stop()

    local attachment = self:getAttachment()

    self:setAttachment(nil)

    if attachment then
        attachment:removeParticle(self:getId())
    end
end

return ElementParticle
