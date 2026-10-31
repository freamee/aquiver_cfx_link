local elements = {}
local stopping = false

local Registry = {}

function Registry.add(element)
    if stopping then
        return false
    end

    elements[element] = true
    return true
end

function Registry.remove(element)
    elements[element] = nil
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    stopping = true

    -- A parent also removes its effects, so iterate over a snapshot.
    local pending = {}
    for element in pairs(elements) do
        pending[#pending + 1] = element
    end

    for _, element in ipairs(pending) do
        local destroyed, err = pcall(element.destroy, element)
        if not destroyed then
            print(("[aquiver_cfx] Failed to destroy element: %s"):format(err))
        end
    end
end)

return Registry