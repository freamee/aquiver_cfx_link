---@class S_CfxAttachmentService
---@field create fun(self: S_CfxAttachmentService, targetSource: number, id: string, definition: IAttachment): IAttachment?
---@field get fun(self: S_CfxAttachmentService, targetSource: number, id: string): IAttachment?
---@field destroy fun(self: S_CfxAttachmentService, targetSource: number, id: string): boolean
---@field remove fun(self: S_CfxAttachmentService, targetSource: number, id: string): boolean
---@field setOffset fun(self: S_CfxAttachmentService, targetSource: number, id: string, position?: vector3, rotation?: vector3, boneIndex?: number): boolean
---@field addSound fun(self: S_CfxAttachmentService, targetSource: number, id: string, soundId: string, audioName: string, audioRef: string): boolean
---@field removeSound fun(self: S_CfxAttachmentService, targetSource: number, id: string, soundId: string): boolean
---@field addParticle fun(self: S_CfxAttachmentService, targetSource: number, id: string, particleId: string, dictionary: string, name: string, position?: vector3, rotation?: vector3, scale?: number): boolean
---@field removeParticle fun(self: S_CfxAttachmentService, targetSource: number, id: string, particleId: string): boolean
---@field setParticleOffset fun(self: S_CfxAttachmentService, targetSource: number, id: string, particleId: string, position?: vector3, rotation?: vector3, scale?: number): boolean
local AttachmentService = {}

-- Keep the registry in aquiver_cfx when this module is included by another resource.
local methods = {
    create = "createAttachment",
    get = "getAttachment",
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
