local resourceState = GetResourceState("qs_inventory")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

print("^4[Aquiver-CFX]^2 Inventory: qs-inventory")

_G.GetInventoryItemCount = function(id)
    return exports["qs-inventory"]:Search(id) or 0
end
