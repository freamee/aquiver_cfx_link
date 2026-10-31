local Attachment = require("runtime.client.attachment")

---@class C_AttachmentManager : OxClass
---@field private _attachments table<number, table<string, C_Attachment>>
---@field private _revisions table<number, table<string, number>>
---@field private _snapshotRevision number
local AttachmentManager = lib.class("C_AttachmentManager")

function AttachmentManager:constructor()
    self._attachments = {}
    self._revisions = {}
    self._snapshotRevision = -1
end

function AttachmentManager:getAttachment(targetSource, id)
    local attachments = self._attachments[targetSource]
    if attachments then
        return attachments[id]
    end
end

function AttachmentManager:removeAttachment(targetSource, id)
    local attachments = self._attachments[targetSource]
    if not attachments or not attachments[id] then
        return
    end

    attachments[id]:destroy()
    attachments[id] = nil

    if not next(attachments) then
        self._attachments[targetSource] = nil
    end
end

function AttachmentManager:setAttachment(targetSource, id, definition)
    local attachment = self:getAttachment(targetSource, id)

    if attachment and attachment:updateDefinition(definition) then
        return
    end

    self:removeAttachment(targetSource, id)

    if not self._attachments[targetSource] then
        self._attachments[targetSource] = {}
    end

    self._attachments[targetSource][id] = Attachment:new(
        targetSource,
        id,
        definition
    )
end

function AttachmentManager:acceptRevision(targetSource, id, revision)
    if revision <= self._snapshotRevision then
        return false
    end

    if not self._revisions[targetSource] then
        self._revisions[targetSource] = {}
    end

    local revisions = self._revisions[targetSource]
    local previous = revisions[id] or -1

    if revision <= previous then
        return false
    end

    revisions[id] = revision
    return true
end

function AttachmentManager:update(targetSource, id, definition, revision)
    if not self:acceptRevision(targetSource, id, revision) then
        return
    end

    self:setAttachment(targetSource, id, definition)
end

function AttachmentManager:delete(targetSource, id, revision)
    if not self:acceptRevision(targetSource, id, revision) then
        return
    end

    self:removeAttachment(targetSource, id)
end

function AttachmentManager:snapshot(state, revision)
    if revision <= self._snapshotRevision then
        return
    end

    -- A snapshot must preserve updates that arrived after it was sent.
    for targetSource, attachments in pairs(self._attachments) do
        local playerState = state[targetSource] or {}
        local revisions = self._revisions[targetSource] or {}

        for id in pairs(attachments) do
            local latest = revisions[id] or -1

            if latest <= revision and not playerState[id] then
                self:removeAttachment(targetSource, id)
            end
        end
    end

    for targetSource, definitions in pairs(state) do
        local revisions = self._revisions[targetSource] or {}

        for id, definition in pairs(definitions) do
            local latest = revisions[id] or -1

            if latest <= revision then
                self:setAttachment(targetSource, id, definition)
            end
        end
    end

    self._snapshotRevision = revision
    self:clearRevisions(revision)
end

function AttachmentManager:clearRevisions(snapshotRevision)
    for targetSource, revisions in pairs(self._revisions) do
        for id, revision in pairs(revisions) do
            if revision <= snapshotRevision then
                revisions[id] = nil
            end
        end

        if not next(revisions) then
            self._revisions[targetSource] = nil
        end
    end
end

function AttachmentManager:reconcile()
    for _, attachments in pairs(self._attachments) do
        for _, attachment in pairs(attachments) do
            attachment:update()
        end
    end
end

function AttachmentManager:destroy()
    for _, attachments in pairs(self._attachments) do
        for _, attachment in pairs(attachments) do
            attachment:destroy()
        end
    end

    self._attachments = {}
    self._revisions = {}
    self._snapshotRevision = -1
end

return AttachmentManager
