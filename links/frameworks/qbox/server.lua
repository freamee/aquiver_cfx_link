local resourceState = GetResourceState("qbx_core")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

_G.GetCash = function(targetSource)
    local Player = exports["qbx_core"]:GetPlayer(targetSource)
    if not Player then return 0 end
    return Player.PlayerData.money.cash or 0
end

_G.AddCash = function(targetSource, amount)
    local Player = exports["qbx_core"]:GetPlayer(targetSource)
    if not Player then return false end
    return Player.Functions.AddMoney("cash", amount)
end

_G.RemoveCash = function(targetSource, amount)
    local Player = exports["qbx_core"]:GetPlayer(targetSource)
    if not Player then return false end
    return Player.Functions.RemoveMoney("cash", amount)
end

_G.GetName = function(targetSource)
    local Player = exports["qbx_core"]:GetPlayer(targetSource)

    if not Player or not Player.PlayerData or not Player.PlayerData.charinfo then
        return GetPlayerName(targetSource) or "Unknown"
    end

    local charinfo = Player.PlayerData.charinfo
    local firstName = charinfo.firstname
    local lastName = charinfo.lastname

    if firstName and lastName then
        return firstName .. ' ' .. lastName
    end

    return GetPlayerName(targetSource) or 'Unknown'
end

_G.GetIdentifier = function(targetSource)
    local Player = exports["qbx_core"]:GetPlayer(targetSource)

    if not Player or not Player.PlayerData then
        return nil
    end

    return Player.PlayerData.citizenid
end

_G.Notification = function(targetSource, message, notifyType, title)
    -- qbx_core verwendet ox_lib für Notifications
    if notifyType == "inform" then notifyType = "info" end

    local notifyData = {
        title = title or "Notification",
        description = message,
        type = notifyType or "info",
        position = 'top-center',
        duration = 5000
    }

    TriggerClientEvent('ox_lib:notify', targetSource, notifyData)
end