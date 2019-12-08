--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Cricital Chance.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "Titan_CTCM"
local CR = 0
local startattribute
-----------------------------------------------
local function OnUpdate(self, id)
	local critical = GetCritChance() or 0;

	if CR == critical then return end
	CR = critical

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (CR - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(string.format("%.2f", (CR - startattribute))).."%".."]"
		elseif (CR - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(string.format("%.2f", (CR - startattribute))).."%".."]"
		end
	end

	local CRtext = "|cFFFFFFFF"..string.format("%.2f", CR) .."%"

	return L["critical"]..": ", CRtext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0%")

	local dif = CR - startattribute -- Cores da conta de valor
	if dif > 0 then
		text = "|cFF69FF69"..(string.format("%.2f", (CR - startattribute))).."%"
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(string.format("%.2f", (CR - startattribute))).."%"
	end

	return L["tooltipDescriptionCha"]..L["critical"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = GetCritChance() or 0
		CR = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["critical"].."|r".." Multi",
	tooltip = L["critical"],
	icon = "Interface\\Icons\\ability_eyeoftheowl",
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
