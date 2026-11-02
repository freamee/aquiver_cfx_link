local Inventory = require("links.inventories.inventory")
local Proficiency = require("server.resources.aqv_proficiency.Proficiency")

local SoundService = require("server.SoundService")

local Notification = require("server.notification.NotificationService")

-- Loading link framework(s)
require("links.frameworks.esx.server")
require("links.frameworks.qbcore.server")
require("links.frameworks.qbox.server")
require("links.frameworks.vrp.server")

-- Loading link inventories
require("links.inventories.one_inventory.server")
require("links.inventories.ox_inventory.server")
require("links.inventories.quasar_inventory.server")

CfxServer = {}

CfxServer.Notify = Notification

CfxServer.Entity = require("server.classes.index")

CfxServer.Sound = SoundService

CfxServer.RemoveCash = function(targetSource, count)
    return _G.RemoveCash(targetSource, count)
end

CfxServer.AddCash = function(targetSource, count)
    return _G.AddCash(targetSource, count)
end

CfxServer.GetCash = function(targetSource)
    return _G.GetCash(targetSource)
end

CfxServer.GetName = function(targetSource)
    return _G.GetName(targetSource)
end

---@return string
CfxServer.GetIdentifier = function(targetSource)
    return _G.GetIdentifier(targetSource) --[[@as string]]
end

CfxServer.Notification = function(targetSource, title, message, type)
    return _G.Notification(targetSource, message, type, title)
end

CfxServer.Inventory = Inventory
CfxServer.Proficiency = Proficiency

RegisterNetEvent("aqv:sound:playNet", function(position, range, audioName, audioRef)
    local playerSource = source
    local dimension = GetPlayerRoutingBucket(playerSource)

    CfxServer.Sound:playAt(
        position,
        dimension,
        range,
        audioName,
        audioRef
    )
end)
