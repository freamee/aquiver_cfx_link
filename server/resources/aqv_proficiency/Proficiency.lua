local Proficiency = {}

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
