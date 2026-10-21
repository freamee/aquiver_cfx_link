local Proficiency = {}

function Proficiency:isResourceStarted()
    return GetResourceState("aqv_proficiency") == "started"
end

function Proficiency:IsReady()
    return self:isResourceStarted()
end

---@param id string
function Proficiency:Serialize(id)
    return exports.oxmysql:serialize(id)
end

function Proficiency:SerializeAll()
    return exports.aqv_proficiency:serializeAll()
end

return Proficiency
