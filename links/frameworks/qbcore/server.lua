local resourceState = GetResourceState("qb-core")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

local QBCore     = exports["qb-core"]:GetCoreObject()

_G.GetCash       = function(targetSource)
    local player = QBCore.Functions.GetPlayer(targetSource)

    return player.Function.GetMoney("cash")
end

_G.AddCash       = function(targetSource, count)
    local player = QBCore.Functions.GetPlayer(targetSource)

    return player.Functions.AddMoney("cash", count)
end

_G.RemoveCash    = function(targetSource, count)
    local player = QBCore.Functions.GetPlayer(targetSource)

    return player.Functions.RemoveMoney("cash", count)
end

_G.GetName       = function(targetSource)
    local player = QBCore.Functions.GetPlayer(targetSource)

    if not player or not player.PlayerData or not player.PlayerData.charinfo then
        return GetPlayerName(targetSource) or "Unknown"
    end

    local charinfo = player.PlayerData.charinfo
    local firstName = charinfo.firstName
    local lastName = charinfo.lastName

    if firstName and lastName then
        return firstName .. " " .. lastName
    end

    return GetPlayerName(targetSource) or "Unknown"
end

_G.GetIdentifier = function(targetSource)
    local player = QBCore.Functions.GetPlayer(targetSource)

    return player.PlayerData.citizenid
end

_G.Notification  = function(targetSource, message, type, title)
    local player = ESX.GetPlayerFromId(targetSource)

    return player.showNotification(message, type, nil, title)
end
