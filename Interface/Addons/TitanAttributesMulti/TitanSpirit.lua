--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Strength.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_SPRTM"
local sprt = 0
local startattribute = 0
-----------------------------------------------
local function OnUpdate(self, id)
	local base, stat, posBuff, negBuff = UnitStat("player", 5) or 0;

	if sprt == base then return end
	sprt = base

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (sprt - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(sprt - startattribute).."]"
		elseif (sprt - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(sprt - startattribute).."]"
		end
	end

	local sprttext = "|cFFFFFFFF"..sprt

	return L["strength"]..": ", sprttext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0")

	local dif = sprt - startattribute
	if dif > 0 then
		text = "|cFF69FF69"..(sprt - startattribute)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(sprt - startattribute)
	end

	return L["tooltipDescriptionExa"]..L["spirit"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = UnitStat("player", 1) or 0
		sprt = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["spirit"].."|r".." Multi",
	tooltip = L["spirit"],
	icon = "Interface\\Icons\\inv_enchant_essencemagiclarge",
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
