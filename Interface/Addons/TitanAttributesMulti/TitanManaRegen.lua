--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Mana Regeneration.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_MARGM"
local MnC, MC = 0, 0
local startattributeNot, startattributeWhile = 0, 0
-----------------------------------------------
local function OnUpdate(self, id)
	local base, casting = GetManaRegen();

	if MnC == base and MC == casting then return end
	MnC = base
--	MC = casting

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		local difBase = MnC - startattributeNot
--		local difCasting = MC - startattributeWhile

		if difBase > 0 then
			BarBalanceText = " |cFF69FF69["..L.SimplifyNumber(difBase).."]"
		elseif difBase < 0 then
			BarBalanceText = " |cFFFF2e2e["..L.SimplifyNumber(difBase).."]"
		end
	end

	local MnCtext = "|cFFFFFFFF"..L.SimplifyNumber(MnC)
--	local MCtext = "|cFFFFFFFF"..L.SimplifyNumber(MC)
	local bar = MnCtext

	return L["manareg"]..": ", bar..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0")

	local dif = MnC - startattributeNot
	if dif > 0 then
		text = "|cFF69FF69"..L.SimplifyNumber(MnC - startattributeNot)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..L.SimplifyNumber(MnC - startattributeNot)
	end

	return L["tooltipDescriptionExa"]..L["manaregtooltip"]..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		MnC, MC = GetManaRegen();
		startattributeNot, startattributeWhile = MnC, MC

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["manareg"].."|r".." Multi",
	tooltip = L["manareg"],
	icon = "Interface\\Icons\\spell_frost_manarecharge",
	category = "Information",
	version = version,
	onUpdate = OnUpdate,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	prepareMenu = L.PrepareAttributesMenu,
	savedVariables = {
		ShowIcon = 1,
		DisplayOnRightSide = false,
		ShowBarBalance = false,
		ShowLabelText = false,
	},
	eventsTable = eventsTable
})
