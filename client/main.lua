Cfx                     = {}

local Tick              = require("shared.Tick")
local lerp              = require("shared.lerp")

-- -- Actor Entities
local Prop              = require("client.classes.Prop")
local Blip              = require("client.classes.Blip")
local Particle          = require("client.classes.Particle")
local Ped               = require("client.classes.Ped")
local Sound             = require("client.classes.Sound")
local Entity            = require("client.classes.Entity")
local Camera            = require("client.classes.Camera")

local Cursor            = require("client.Cursor")
local GameCursor        = require("client.GameCursor")
local GameplayCamera    = require("client.GameplayCamera")
local Graphics          = require("client.Graphics")
local DrawSpriteMeter   = require("client.DrawSpriteMeter")
local DrawSpriteMeter3D = require("client.DrawSpriteMeter3D")

Cfx.lerp                = lerp
Cfx.Tick                = Tick

Cfx.Graphics            = Graphics
Cfx.GameplayCamera      = GameplayCamera
Cfx.Cursor              = Cursor
Cfx.GameCursor          = GameCursor
Cfx.DrawSpriteMeter     = DrawSpriteMeter
Cfx.DrawSpriteMeter3D   = DrawSpriteMeter3D

-- -- Registering actor entities.
Cfx.Actor               = {}
Cfx.Actor.Camera        = Camera
Cfx.Actor.Blip          = Blip
Cfx.Actor.Entity        = Entity
Cfx.Actor.Particle      = Particle
Cfx.Actor.Ped           = Ped
Cfx.Actor.Prop          = Prop
Cfx.Actor.Sound         = Sound

-- Creating & Loading the texture(s)
local txd               = CreateRuntimeTxd("aquiver_cfx")
CreateRuntimeTextureFromImage(txd, "interaction_bg", "txd/interaction_bg.png")

CfxClient = {}
