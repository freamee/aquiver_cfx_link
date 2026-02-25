local resourceState = GetResourceState("es_extended")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

local ESX = exports['es_extended']:getSharedObject()

_G.GetCash = function(targetSource)
    local player = ESX.GetPlayerFromId(targetSource)

    return player.getMoney()
end

_G.AddCash = function(targetSource, count)
    local player = ESX.GetPlayerFromId(targetSource)

    return player.addMoney(count)
end

_G.RemoveCash = function(targetSource, count)
    local player = ESX.GetPlayerFromId(targetSource)

    return player.removeMoney(count)
end

_G.GetName = function(targetSource)
    local player = ESX.GetPlayerFromId(targetSource)

    return player.getName()
end

_G.GetIdentifier = function(targetSource)
    local player = ESX.GetPlayerFromId(targetSource)

    return player.getIdentifier()
end

_G.Notification = function(targetSource, message, type, title)
    local player = ESX.GetPlayerFromId(targetSource)

    return player.showNotification(message, type, nil, title)
end
