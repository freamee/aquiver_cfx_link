---@class ProficiencyDefinition
---@field id string Unique, namespaced identifier (for example: "miner.mining").
---@field name string Display name.
---@field description? string Display description.
---@field image? string Image path relative to the registering resource.
---@field maxPoints number Maximum number of obtainable points.

local Proficiency = {}

---@param proficiency ProficiencyDefinition
function Proficiency.Register(proficiency)
    return exports.aqv_proficiency:registerProficiency(proficiency)
end

---@param targetSource number
---@param id string
---@param count number
function Proficiency.Add(targetSource, id, count)
    return exports.aqv_proficiency:addPoint(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@param count number
function Proficiency.Remove(targetSource, id, count)
    return exports.aqv_proficiency:removePoint(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@param count number
function Proficiency.Set(targetSource, id, count)
    return exports.aqv_proficiency:setPoint(targetSource, id, count)
end

---@param targetSource number
---@param id string
function Proficiency.Get(targetSource, id)
    return exports.aqv_proficiency:getPoint(targetSource, id)
end

---@param id string
function Proficiency.GetProficiency(id)
    return exports.aqv_proficiency:getProficiency(id)
end

function Proficiency.GetProficiencies()
    return exports.aqv_proficiency:getProficiencies()
end

return Proficiency
