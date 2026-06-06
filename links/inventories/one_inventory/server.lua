local resourceState = GetResourceState("one_inventory")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

print("^4[Aquiver-CFX]^2 Inventory: one_inventory")

_G.AddInventoryItem = function(targetSource, id, count)
    return exports["one_inventory"]:AddItem(targetSource, id, count)
end

_G.RemoveInventoryItem = function(targetSource, id, count)
    return exports["one_inventory"]:RemoveItem(targetSource, id, count)
end

_G.HasInventoryItem = function(targetSource, id)
    return exports["one_inventory"]:HasItem(targetSource, id, 1)
end

_G.CanCarryItem = function(targetSource, id, count)
    return exports["one_inventory"]:CanCarryItem(targetSource, id, count)
end

_G.GetInventoryItemCount = function(targetSource, id)
    return exports["one_inventory"]:GetItemCount(targetSource, id)
end
