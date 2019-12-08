--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Ranged Power.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_RAPM"
local RP = 0
local startattribute
-----------------------------------------------
local function OnUpdate(self, id)
	local base, posBuff, negBuff = UnitRangedAttackPower("player");
	local rangedpower = (base and base + posBuff + negBuff) or 0;

	if RP == rangedpower then return end
	RP = rangedpower

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (RP - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(RP - startattribute).."]"
		elseif (RP - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(RP - startattribute).."]"
		end
	end

	local RPtext = "|cFFFFFFFF"..RP

	return L["rangedpower"]..": ", RPtext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0%")

	local dif = RP - startattribute -- Cores da conta de valor
	if dif > 0 then
		text = "|cFF69FF69"..(RP - startattribute)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(RP - startattribute)
	end

	return L["tooltipDescriptionExa"]..L["rangedpower"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = UnitRangedAttackPower("player") or 0
		RP = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["rangedpower"].."|r".." Multi",
	tooltip = L["rangedpower"],
	icon = "Interface\\Icons\\inv_musket_02.blp",
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
