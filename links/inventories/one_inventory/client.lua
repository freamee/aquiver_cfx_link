local resourceState = GetResourceState("one_inventory")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

print("^4[Aquiver-CFX]^2 Inventory: one_inventory")

_G.GetInventoryItemCount = function(id)
    return exports["one_inventory"]:GetItemCount(id)
end
