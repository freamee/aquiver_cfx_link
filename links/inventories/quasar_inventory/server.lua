local resourceState = GetResourceState("qs-inventory")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

print("^4[Aquiver-CFX]^2 Inventory: qs-inventory")

_G.AddInventoryItem = function(targetSource, id, count)
    return exports['qs-inventory']:AddItem(targetSource, id, count)
end

_G.RemoveInventoryItem = function(targetSource, id, count)
    return exports['qs-inventory']:RemoveItem(targetSource, id, count)
end

_G.HasInventoryItem = function(targetSource, id)
    local itemCount = exports['qs-inventory']:GetItemTotalAmount(targetSource, id)

    return itemCount > 0
end

_G.CanCarryItem = function(targetSource, id, count)
    return exports['qs-inventory']:CanCarryItem(targetSource, id, count)
end

_G.GetInventoryItemCount = function(targetSource, id)
    local itemCount = exports['qs-inventory']:GetItemTotalAmount(targetSource, id)

    return itemCount
end
