--[[
Description: This plugin is part of the "Titan Panel [Professions] Multi" addon. It shows your Tailoring skill level.
Site: http://www.curse.com/addons/wow/titan-panel-professions-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local LibAddonCompat = LibStub("LibAddonCompat-1.0")
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TAIM"
local TAIM, prevTAIM = 0.0, -2
local TAIMmax = 0
local TAIMIncrease = 0
local startskill
-----------------------------------------------
local function OnClick(self, button)
	if (button == "LeftButton") then
		local prof = L["tailoring"]
		CastSpellByName(prof)
	end
end
-----------------------------------------------
local function OnUpdate(self, id)
	local prof1, prof2 = LibAddonCompat:GetProfessions();

	local skillLevel = 0
	local maxSkillLevel = 0

	if prof1 ~= nil then
		local name, _, skillLevel, maxSkillLevel, _, _, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof1)
		if name == L["tailoring"] then
			TAIM = skillLevel
			TAIMmax = maxSkillLevel
			TAIMIncrease = IncreaseSkillLevel
			if not startskill then startskill = skillLevel end
		elseif prof2 ~= nil then
			local name, _, skillLevel, maxSkillLevel, _, _, _, IncreaseSkillLevel = LibAddonCompat:GetProfessionInfo(prof2)
			if name == L["tailoring"] then
				TAIM = skillLevel
				TAIMmax = maxSkillLevel
				TAIMIncrease = IncreaseSkillLevel
				if not startskill then startskill = skillLevel end
			end
		end
	end

	if TAIM == prevTAIM and TAIMmax == preTAIMmax and prevTAIMIncrease == TAIMIncrease then
		return
	end

	preTAIMmax = TAIMmax
	prevTAIM = TAIM
	prevTAIMIncrease = TAIMIncrease

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local TAIMtext
	local bonusText = ""
	if TAIMIncrease and TAIMIncrease > 0 then -- Bônus da profissão
		bonusText = "|r|cFFFFFFFF".." + |r|cFF69FF69"..TAIMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(TAIM+TAIMIncrease)
	end
	local HideText = "" -- Texto HideMax
	if not TitanGetVar(ID, "HideMax") then
		HideText = "|r/|cFFFF2e2e"..TAIMmax
	end
	local SimpleText = bonusText -- Texto de bônus simples
	if TitanGetVar(ID, "SimpleBonus") and TAIMIncrease > 0 then
		SimpleText = "|r|cFFFFFFFF".." (+|r|cFF69FF69"..TAIMIncrease.."|r|cFFFFFFFF)"
	end

	local BarBalanceText = ""
	if TAIMmax ~= 0 and (TAIM - startskill) > 0 and TitanGetVar(ID, "ShowBarBalance") then
		BarBalanceText = " |cFF69FF69["..(TAIM - startskill).."]"
	end

	if TAIM == 300 then
		TAIMtext = "|cFF69FF69"..L["maximum"].."!"..SimpleText
	elseif TAIMmax == 0 then
		TAIMtext = "|cFFFF2e2e"..L["noprof"]
	elseif TAIM == TAIMmax then
		TAIMtext = "|cFFFFFFFF"..TAIM.."|cFFFF2e2e! ["..L["maximum"].."]"..SimpleText..BarBalanceText
	else
		TAIMtext = "|cFFFFFFFF"..TAIM..HideText..SimpleText..BarBalanceText
	end

	return L["tailoring"]..": ", TAIMtext
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local BonusTooltip = L["craftsmanship"].."|r|cFFFFFFFF"..TAIM.." + |r|cFF69FF69"..TAIMIncrease.."|r|cFFFFFFFF "..L["bonus"].." =|r|cFF69FF69 "..(TAIM+TAIMIncrease) -- Bônus da profissão

	local Goodwith = L["goodwith"]..L["enchanting"] -- Texto de combinação

	local maxtext = L["maxtext"]..TitanUtils_GetHighlightText(TAIMmax)

	local ColorValueAccount -- Conta de ganho de perícia
	if not TAIM then
		ColorValueAccount = ""
	elseif TAIM == 300 then
		ColorValueAccount = "\r"..L["maxskill"]
	elseif not startskill  or (TAIM - startskill) == 0 then
		ColorValueAccount = "\r"..L["session"]..TitanUtils_GetHighlightText("0")
	elseif (TAIM - startskill) > 0 then
		ColorValueAccount = "\r"..L["session"].."|cFF69FF69"..(TAIM - startskill).."|r"
	end

	local warning -- Aviso de que não está mais aprendendo
	if TAIMmax == 300 then
		warning = ""
	elseif TAIM == TAIMmax then
		warning = L["warning"]
	else
		warning = ""
	end

	local ValueText = "" -- Difere com e sem profissão
	if TAIM == 0 then
		ValueText = L["noskill"]..Goodwith
	else
		ValueText = L["hint"]..L["info"]..BonusTooltip..maxtext..ColorValueAccount..Goodwith..warning
	end

	return ValueText
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|c22fdce08 "..L["tailoring"].."|r".." Multi",
	tooltip = L["tailoring"],
	icon = "Interface\\Icons\\Trade_tailoring.blp",
	category = "Profession",
	version = version,
	onUpdate = OnUpdate,
	onClick = OnClick,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	prepareMenu = L.PrepareProfessionsMenu,
	savedVariables = {
		ShowIcon = 1,
		DisplayOnRightSide = false,
		HideMax = false,
		SimpleBonus = true,
		ShowBarBalance = false,
		ShowLabelText = false,
	}
})
