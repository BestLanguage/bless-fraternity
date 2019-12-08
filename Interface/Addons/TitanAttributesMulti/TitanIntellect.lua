--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Intellect.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_INLLM"
local int = 0
local startattribute = 0
-----------------------------------------------
local function OnUpdate(self, id)
	local base, stat, posBuff, negBuff = UnitStat("player", 4) or 0;

	if int == base then return end
	int = base

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (int - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(int - startattribute).."]"
		elseif (int - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(int - startattribute).."]"
		end
	end

	local inttext = "|cFFFFFFFF"..int

	return L["intellect"]..": ", inttext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0")

	local dif = int - startattribute
	if dif > 0 then
		text = "|cFF69FF69"..(int - startattribute)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(int - startattribute)
	end

	return L["tooltipDescriptionExa"]..L["intellect"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = UnitStat("player", 4) or 0
		int = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["intellect"].."|r".." Multi",
	tooltip = L["intellect"],
	icon = "Interface\\Icons\\spell_holy_arcaneintellect",
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
