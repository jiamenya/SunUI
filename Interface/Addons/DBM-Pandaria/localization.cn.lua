﻿-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 9/27/2012

if GetLocale() ~= "zhCN" then return end
local L

-----------------------
-- Sha of Anger --
-----------------------
L= DBM:GetModLocalization(691)

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能",
	RangeFrame			= "距离监视：$spell:119622",
	HudMAP				= "高级定位监视(HUD)：$spell:119622",
	SetIconOnMC			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(119622)
})

-----------------------
-- Salyis --
-----------------------
L= DBM:GetModLocalization(725)

L:SetOptionLocalization({
	SoundWOP			= "语音警告：重要技能"
})