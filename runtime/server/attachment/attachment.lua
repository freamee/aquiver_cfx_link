local Service = require("runtime.server.attachment.attachment_service")

---@class S_Attachment : OxClass
---@field private _targetSource number
---@field private _id string
local Attachment = lib.class("S_Attachment")

---@param targetSource number
---@param id string
function Attachment:constructor(targetSource, id)
    self._targetSource = tonumber(targetSource)
    self._id = id
end

function Attachment:getId()
    return self._id
end

function Attachment:getTargetSource()
    return self._targetSource
end

function Attachment:isDestroyed()
    return self:toDefinition() == nil
end

function Attachment:toDefinition()
    return Service:get(self._targetSource, self._id)
end

---@param position? vector3
---@param rotation? vector3
---@param boneIndex? number
function Attachment:setOffset(position, rotation, boneIndex)
    return Service:setOffset(self._targetSource, self._id, position, rotation, boneIndex)
end

---@param soundId string
---@param audioName string
---@param audioRef string
function Attachment:addSound(soundId, audioName, audioRef)
    return Service:addSound(self._targetSource, self._id, soundId, audioName, audioRef)
end

---@param soundId string
function Attachment:removeSound(soundId)
    return Service:removeSound(self._targetSource, self._id, soundId)
end

---@param particleId string
---@param dictionary string
---@param name string
---@param position? vector3
---@param rotation? vector3
---@param scale? number
function Attachment:addParticle(particleId, dictionary, name, position, rotation, scale)
    return Service:addParticle(self._targetSource, self._id, particleId, dictionary, name, position, rotation, scale)
end

---@param particleId string
function Attachment:removeParticle(particleId)
    return Service:removeParticle(self._targetSource, self._id, particleId)
end

---@param particleId string
---@param position? vector3
---@param rotation? vector3
---@param scale? number
function Attachment:setParticleOffset(particleId, position, rotation, scale)
    return Service:setParticleOffset(self._targetSource, self._id, particleId, position, rotation, scale)
end

function Attachment:destroy()
    return Service:destroy(self._targetSource, self._id)
end

return Attachment
