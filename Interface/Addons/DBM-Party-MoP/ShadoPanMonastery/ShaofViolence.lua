﻿local mod	= DBM:NewMod(685, "DBM-Party-MoP", 3, 312)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 7902 $"):sub(12, -3))
mod:SetCreatureID(56719)
mod:SetModelID(43283)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warnDisorientingSmash		= mod:NewTargetAnnounce(106872, 2)
local warnShaSpike				= mod:NewTargetAnnounce(106877, 3)
local warnEnrage				= mod:NewSpellAnnounce(38166, 4)

local specWarnShaSpike			= mod:NewSpecialWarningMove(106877)

local timerDisorientingSmashCD	= mod:NewCDTimer(13, 106872)--variables. not confirmed
local timerShaSpikeCD			= mod:NewNextTimer(9, 106877)

function mod:ShaSpikeTarget()
	local targetname = self:GetBossTarget(56719)
	if not targetname then return end
	warnShaSpike:Show(targetname)
	if targetname == UnitName("player") then
		specWarnShaSpike:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runaway.mp3")--快躲開
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(38166) then
		warnEnrage:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(106877) then
		self:ScheduleMethod(0.1, "ShaSpikeTarget")
		timerShaSpikeCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(106872) then
		warnDisorientingSmash:Show(args.destName)
		timerDisorientingSmashCD:Start()
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\dispelnow.mp3")--快驅散
		end
	end
end