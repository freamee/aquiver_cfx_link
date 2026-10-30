local AttachmentRegistry = {}
---@type number
AttachmentRegistry._revision = 0
---@type table<number, table<string, S_ElementProp>>
AttachmentRegistry._attachments = {}

---@param targetSource number
---@param id string
function AttachmentRegistry:get(targetSource, id)
    local entities = self._attachments[targetSource]

    if entities then
        return entities[id]
    end
end

---@param targetSource number
---@param attachment S_ElementProp
function AttachmentRegistry:publish(targetSource, attachment)
    local id = attachment:getId()
    local previous = self:get(targetSource, id)

    if previous and previous ~= attachment then
        previous:destroy()
    end

    if not self._attachments[targetSource] then
        self._attachments[targetSource] = {}
    end

    self._attachments[targetSource][id] = attachment
    self._revision = self._revision + 1

    TriggerClientEvent(
        "aquiver::attachments::update",
        -1,
        targetSource,
        id,
        attachment:toDefinition(),
        self._revision
    )
end

---@param targetSource number
---@param attachment S_ElementProp
function AttachmentRegistry:remove(targetSource, attachment)
    local id = attachment:getId()

    if self:get(targetSource, id) ~= attachment then
        return false
    end

    local entities = self._attachments[targetSource]

    entities[id] = nil

    if not next(entities) then
        self._attachments[targetSource] = nil
    end

    self._revision = self._revision + 1

    TriggerClientEvent(
        "aquiver::attachments::delete",
        -1,
        targetSource,
        id,
        self._revision
    )

    return true
end

function AttachmentRegistry:snapshot()
    local state = {}

    for targetSource, entities in pairs(self._attachments) do
        state[targetSource] = {}

        for id, attachment in pairs(entities) do
            state[targetSource][id] = attachment:toDefinition()
        end
    end

    return state, self._revision
end

---@param targetSource number
function AttachmentRegistry:onPlayerQuit(targetSource)
    local entities = self._attachments[targetSource]

    if not entities then
        return
    end

    for _, attachment in pairs(entities) do
        attachment:destroy()
    end
end

---@param resourceName string
function AttachmentRegistry:onResourceStop(resourceName)
    local stoppingThisResource = resourceName == GetCurrentResourceName()

    for _, entities in pairs(self._attachments) do
        for _, attachment in pairs(entities) do
            if stoppingThisResource or attachment:getOwnerResource() == resourceName then
                attachment:destroy()
            end
        end
    end
end

return AttachmentRegistry
