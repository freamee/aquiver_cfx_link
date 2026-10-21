---@class ProficiencyOptions
---@field id string
---@field name string
---@field icon string
---@field description string
---@field multiplier number
---@field baseXp number
---@field pointCap number
---@field milestones ProficiencyMilestoneOptions[]

---@class ProficiencyMilestoneOptions
---@field id string
---@field name string
---@field value number
---@field level number

---@class IProficiency
---@field id string
---@field name string
---@field description string
---@field icon string
---@field pointCap number
---@field baseXp number
---@field multiplier number
---@field resource string
---@field milestones IProficiencyMilestone[]

---@class IProficiencyMilestone
---@field id string
---@field name string
---@field level number
---@field value number

local Proficiency = {}

---@param options ProficiencyOptions
function Proficiency.Register(options)
    return exports.aqv_proficiency:register(options)
end

---@param id string
---@return IProficiency
function Proficiency.Get(id)
    return exports.aqv_proficiency:get(id)
end

---@return IProficiency[]
function Proficiency.GetAll()
    return exports.aqv_proficiency:getAll()
end

function Proficiency:IsReady()
    return GetResourceState("aqv_proficiency") == "started"
end

---@param targetSource number
---@param id string
---@param count number
function Proficiency.AddPoint(targetSource, id, count)
    return exports.aqv_proficiency:addPoint(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@param count number
function Proficiency.RemovePoint(targetSource, id, count)
    return exports.aqv_proficiency:removePoint(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@param count number
function Proficiency.SetPoint(targetSource, id, count)
    return exports.aqv_proficiency:setPoint(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@return number
function Proficiency.GetPoint(targetSource, id)
    return exports.aqv_proficiency:getPoint(targetSource, id)
end

---@param targetSource number
---@param id string
function Proficiency:GetLevel(targetSource, id)
    return exports.aqv_proficiency:getLevel(targetSource, id)
end

function Proficiency:GetCurrentXp(targetSource, id)
    return exports.aqv_proficiency:getCurrentXp(targetSource, id)
end

---@param targetSource number
---@param id string
function Proficiency:GetRequiredXp(targetSource, id)
    return exports.aqv_proficiency:getRequiredXp(targetSource, id)
end

---@param targetSource number
---@param id string
function Proficiency:GetNextRequiredXp(targetSource, id)
    return exports.aqv_proficiency:getNextRequiredXp(targetSource, id)
end

return Proficiency
