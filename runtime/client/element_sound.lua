local Element = require("lua.client.Element")

---@class C_ElementSound : C_Element
---@field private _audioName string
---@field private _audioRef string
---@field private _soundId number?
local ElementSound = lib.class("C_ElementSound", Element)

---@param id string
---@param audioName string
---@param audioRef string
function ElementSound:constructor(id, audioName, audioRef)
    self:super(id)

    self._audioName = audioName
    self._audioRef = audioRef
end

---@param element C_ElementProp
---@return boolean
function ElementSound:attach(element)
    self:stop()

    if self:isDestroyed() or element:isDestroyed() then
        return false
    end

    local entity = element:getScriptId()
    if not entity or not DoesEntityExist(entity) then
        return false
    end

    self._soundId = GetSoundId()
    if self._soundId == -1 then
        self._soundId = nil
        error(("No sound ID available for '%s'"):format(self._audioName), 2)
    end

    PlaySoundFromEntity(
        self._soundId,
        self._audioName,
        entity,
        self._audioRef,
        false,
        0
    )

    return true
end

function ElementSound:stop()
    if self._soundId ~= nil then
        StopSound(self._soundId)
        ReleaseSoundId(self._soundId)
        self._soundId = nil
    end
end

function ElementSound:destroy()
    if self:isDestroyed() then
        return
    end

    Element.destroy(self)
    self:stop()

    local attachment = self:getAttachment()
    self:setAttachment(nil)

    if attachment then
        attachment:removeSound(self:getId())
    end
end

return ElementSound
