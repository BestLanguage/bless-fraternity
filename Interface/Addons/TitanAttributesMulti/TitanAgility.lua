--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Agility.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_AGLTYM"
local aglty = 0
local startattribute = 0
-----------------------------------------------
local function OnUpdate(self, id)
	local base, stat, posBuff, negBuff = UnitStat("player", 2) or 0;

	if aglty == base then return end
	aglty = base

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (aglty - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(aglty - startattribute).."]"
		elseif (aglty - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(aglty - startattribute).."]"
		end
	end

	local agltytext = "|cFFFFFFFF"..aglty

	return L["agility"]..": ", agltytext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0")

	local dif = aglty - startattribute
	if dif > 0 then
		text = "|cFF69FF69"..(aglty - startattribute)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(aglty - startattribute)
	end

	return L["tooltipDescriptionExa"]..L["agility"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = UnitStat("player", 2) or 0
		aglty = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["agility"].."|r".." Multi",
	tooltip = L["agility"],
	icon = "Interface\\Icons\\ability_rogue_sprint",
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
