--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Dodge Chance.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_DDGM"
local DG = 0
local startattribute
-----------------------------------------------
local function OnUpdate(self, id)
	local dodge = GetDodgeChance() or 0;

	if DG == dodge then return end
	DG = dodge

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (DG - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(string.format("%.2f", (DG - startattribute))).."%".."]"
		elseif (DG - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(string.format("%.2f", (DG - startattribute))).."%".."]"
		end
	end

	local DGtext = "|cFFFFFFFF"..string.format("%.2f", DG) .."%"

	return L["dodge"]..": ", DGtext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0%")

	local dif = DG - startattribute -- Cores da conta de valor
	if dif > 0 then
		text = "|cFF69FF69"..(string.format("%.2f", (DG - startattribute))).."%"
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(string.format("%.2f", (DG - startattribute))).."%"
	end

	return L["tooltipDescriptionCha"]..L["dodge"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = GetDodgeChance() or 0
		DG = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["dodge"].."|r".." Multi",
	tooltip = L["dodget"],
	icon = "Interface\\Icons\\spell_nature_invisibilty.blp",
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
