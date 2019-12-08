--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Block Chance.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_BLKM"
local BK = 0
local startattribute = 0
-----------------------------------------------
local function OnUpdate(self, id)
	local block = GetBlockChance() or 0;

	if BK == block then return end
	BK = block

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (BK - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(string.format("%.2f", (BK - startattribute))).."%".."]"
		elseif (BK - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(string.format("%.2f", (BK - startattribute))).."%".."]"
		end
	end

	local BKtext = "|cFFFFFFFF"..string.format("%.2f", BK) .."%"

	return L["block"]..": ", BKtext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0%")

	local dif = BK - startattribute
	if dif > 0 then
		text = "|cFF69FF69"..(string.format("%.2f", (BK - startattribute))).."%"
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(string.format("%.2f", (BK - startattribute))).."%"
	end

	return L["tooltipDescriptionCha"]..L["block"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = GetBlockChance() or 0
		BK = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["block"].."|r".." Multi",
	tooltip = L["blockt"],
	icon = "Interface\\Icons\\ability_defend.blp",
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
