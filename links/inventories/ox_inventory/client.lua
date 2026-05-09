local resourceState = GetResourceState("ox_inventory")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

print("^4[Aquiver-CFX]^2 Inventory: ox_inventory")

_G.GetInventoryItemCount = function(id)
    return exports["ox_inventory"]:GetItemCount(id)
end
