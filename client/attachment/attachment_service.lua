---@class C_CfxAttachmentService
---@field create fun(self: C_CfxAttachmentService, id: string, definition: IAttachment): boolean
---@field get fun(self: C_CfxAttachmentService, id: string, targetSource?: number): IAttachment?
---@field getEntity fun(self: C_CfxAttachmentService, id: string, targetSource?: number): number?
---@field destroy fun(self: C_CfxAttachmentService, id: string): boolean
---@field remove fun(self: C_CfxAttachmentService, id: string): boolean
---@field setOffset fun(self: C_CfxAttachmentService, id: string, position?: vector3, rotation?: vector3, boneIndex?: number): boolean
---@field addSound fun(self: C_CfxAttachmentService, id: string, soundId: string, audioName: string, audioRef: string): boolean
---@field removeSound fun(self: C_CfxAttachmentService, id: string, soundId: string): boolean
---@field addParticle fun(self: C_CfxAttachmentService, id: string, particleId: string, dictionary: string, name: string, position?: vector3, rotation?: vector3, scale?: number): boolean
---@field removeParticle fun(self: C_CfxAttachmentService, id: string, particleId: string): boolean
---@field setParticleOffset fun(self: C_CfxAttachmentService, id: string, particleId: string, position?: vector3, rotation?: vector3, scale?: number): boolean
local AttachmentService = {}

-- This module is included by other resources; the runtime lives in aquiver_cfx.
local methods = {
    create = "createAttachment",
    get = "getAttachment",
    getEntity = "getAttachmentEntity",
    destroy = "destroyAttachment",
    setOffset = "setAttachmentOffset",
    addSound = "addAttachmentSound",
    removeSound = "removeAttachmentSound",
    addParticle = "addAttachmentParticle",
    removeParticle = "removeAttachmentParticle",
    setParticleOffset = "setAttachmentParticleOffset",
}

for method, exportName in pairs(methods) do
    AttachmentService[method] = function(self, ...)
        return exports.aquiver_cfx[exportName](nil, ...)
    end
end

AttachmentService.remove = AttachmentService.destroy

return AttachmentService
