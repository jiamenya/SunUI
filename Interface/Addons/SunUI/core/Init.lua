﻿local addon, engine = ...
engine[1] = {} -- T, functions, constants, variables
engine[2] = {} -- C, config
engine[3] = {} -- L, localization
engine[4] = {} -- G, globals (Optionnal)

SunUI = engine
local SunUI = LibStub("AceAddon-3.0"):NewAddon("SunUI")
local S, C, L, DB = unpack(select(2, ...))
local _G =_G
local _
--全局设置
local Media = "Interface\\Addons\\SunUI\\media\\"
DB.dummy = function() return end
DB.zone = GetLocale()
DB.level = UnitLevel("player")
DB.MyClass = select(2, UnitClass("player"))
DB.PlayerName = select(1, UnitName("player"))
DB.MyClassColor = RAID_CLASS_COLORS[DB.MyClass]
DB.Font = GameFontNormal:GetFont()
DB.Solid = Media.."solid"
DB.Button = Media.."Button"
DB.GlowTex = Media.."glowTex"
DB.Statusbar = Media.."gloss"
--DB.Statusbar = "Interface\\Buttons\\WHITE8x8" --Media.."dM3"
DB.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
DB.edgetex = 	"Interface\\Tooltips\\UI-Tooltip-Border"
DB.aurobackdrop = "Interface\\ChatFrame\\ChatFrameBackground"
DB.onepx = "Interface\\Buttons\\WHITE8x8"
DB.Warning = Media.."Warning.mp3"
DB.MyRealm = GetRealmName()