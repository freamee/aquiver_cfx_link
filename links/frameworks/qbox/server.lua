local resourceState = GetResourceState("qbx_core")

if resourceState ~= "started" and resourceState ~= "starting" then
    return
end

_G.getCash       = function(targetSource)
    return exports["qbx_core"]:GetMoney(targetSource, 'cash')
end

_G.addCash       = function(targetSource, count)
    return exports["qbx_core"]:AddMoney(targetSource, "cash", count)
end

_G.removeCash    = function(targetSource, count)
    return exports["qbx_core"]:RemoveMoney(targetSource, 'cash', amount)
end

_G.getName       = function(targetSource)
    local player = exports["qbx_core"]:GetPlayer(targetSource)

    if not player or not player.PlayerData or not player.PlayerData.charinfo then
        return GetPlayerName(targetSource) or "Unknown"
    end

    local charinfo = player.PlayerData.charinfo
    local firstName = charinfo.firstname
    local lastName = charinfo.lastname

    if firstName and lastName then
        return firstName .. ' ' .. lastName
    end

    return GetPlayerName(player) or 'Unknown'
end

_G.getIdentifier = function(targetSource)
    local player = exports["qbx_core"]:GetPlayer(targetSource)

    return player.PlayerData.citizenid
end

_G.notification  = function(targetSource, message, type, title)
    return exports["qbx_core"]:Notify(targetSource, message, type, nil, title)
end
