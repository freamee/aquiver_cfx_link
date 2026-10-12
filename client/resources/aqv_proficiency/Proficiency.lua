local Proficiency = {}

function Proficiency:isResourceStarted()
    return GetResourceState("aqv_proficiency") == "started"
end

function Proficiency:isReady()
    return self:isResourceStarted() and exports.aqv_proficiency:isReady()
end

function Proficiency:getProficiencies()
    return exports.aqv_proficiency:getProficiencies()
end

---@param id string
function Proficiency:getProficiency(id)
    return exports.aqv_proficiency:getProficiency(id)
end

---@param id string
function Proficiency:getPoint(id)
    return exports.aqv_proficiency:getPoint(id)
end

function Proficiency:getPlayerProficiencies()
    return exports.aqv_proficiency:getPlayerProficiencies()
end

return Proficiency
