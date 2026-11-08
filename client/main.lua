Cfx                     = {}

local GameCursor        = require("client.GameCursor")
local GameplayCamera    = require("client.GameplayCamera")
local Graphics          = require("client.Graphics")
local DrawSpriteMeter   = require("client.DrawSpriteMeter")
local DrawSpriteMeter3D = require("client.DrawSpriteMeter3D")
local Game              = require("client.Game")

local Notification      = require("client.notification.Notification")

local Proficiency       = require("client.resources.aqv_proficiency.Proficiency")

local SoundService      = require("client.SoundService")
local AttachmentService = require("client.attachment.attachment_service")

require("links.inventories.one_inventory.client")
require("links.inventories.ox_inventory.client")
require("links.inventories.quasar_inventory.client")
require("links.frameworks.esx.client")
require("links.frameworks.qbcore.client")
require("links.frameworks.qbox.client")
require("links.frameworks.vrp.client")

Cfx.Graphics          = Graphics
Cfx.GameplayCamera    = GameplayCamera
Cfx.GameCursor        = GameCursor
Cfx.DrawSpriteMeter   = DrawSpriteMeter
Cfx.DrawSpriteMeter3D = DrawSpriteMeter3D
Cfx.Game              = Game

Cfx.Animation         = require("client.animation.index")

Cfx.Sound             = SoundService
Cfx.Attachment        = AttachmentService
Cfx.AttachmentService = AttachmentService

Cfx.Notification      = Notification

Cfx.Entity            = require("client.classes.index")

local Inventory       = require("client.inventories.inventory")

CfxClient             = {}
CfxClient.Inventory   = Inventory
CfxClient.Proficiency = Proficiency

RegisterNetEvent("aquiver:notificationPop", function(...)
    Cfx.Notification:addPop(...)
end)
RegisterNetEvent("SoundService::PlayAt", function(...)
    Cfx.Sound:playAt(...)
end)
