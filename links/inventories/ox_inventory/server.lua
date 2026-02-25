_G.AddInventoryItem = function(targetSource, id, count)
    return exports["ox_inventory"]:AddItem(targetSource, id, count)
end

_G.RemoveInventoryItem = function(targetSource, id, count)
    return exports["ox_inventory"]:RemoveItem(targetSource, id, count)
end

_G.HasInventoryItem = function(targetSource, id)
    return exports["ox_inventory"]:GetItemCount(targetSource, id) > 0
end

_G.CanCarryItem = function(targetSource, id, count)
    return exports["ox_inventory"]:CanCarryItem(targetSource, id, count)
end
