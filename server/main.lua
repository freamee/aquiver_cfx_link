local Vehicle = require("server.classes.Vehicle")
local Prop = require("server.classes.Prop")
local Actor = require("server.classes.Entity")
local Ped = require("server.classes.Ped")

local Inventory = require("links.inventories.inventory")
local Proficiency = require("resources.aqv_proficiency.Proficiency")

CfxServer = {}

CfxServer.Actor = {}
CfxServer.Actor.Vehicle = Vehicle
CfxServer.Actor.Entity = Actor
CfxServer.Actor.Prop = Prop
CfxServer.Actor.Ped = Ped

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
