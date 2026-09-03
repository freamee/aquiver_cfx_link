local Inventory = {}

function Inventory.GetItemCount(id)
    return _G.GetInventoryItemCount(id)
end

return Inventory
