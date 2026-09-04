local Inventory = {}

---@param targetSource number
---@param id string
---@param count number
function Inventory.Add(targetSource, id, count)
    return _G.AddInventoryItem(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@param count number
function Inventory.Remove(targetSource, id, count)
    return _G.RemoveInventoryItem(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@return boolean
function Inventory.Has(targetSource, id)
    return _G.HasInventoryItem(targetSource, id)
end

---@param targetSource number
---@param id string
---@param count number
function Inventory.CanCarryItem(targetSource, id, count)
    return _G.CanCarryItem(targetSource, id, count)
end

---@param targetSource number
---@param id string
---@return number
function Inventory.GetItemCount(targetSource, id)
    return _G.GetInventoryItemCount(targetSource, id)
end

return Inventory
