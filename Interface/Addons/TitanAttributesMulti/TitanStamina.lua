--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Stamina.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_STMNM"
local STAM = 0
local startattribute = 0
-----------------------------------------------
local function OnUpdate(self, id)
	local base, stat, posBuff, negBuff = UnitStat("player", 3) or 0;

	if STAM == base then return end
	STAM = base

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (STAM - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(STAM - startattribute).."]"
		elseif (STAM - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(STAM - startattribute).."]"
		end
	end

	local STAMtext = "|cFFFFFFFF"..STAM

	return L["stamina"]..": ", STAMtext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0")

	local dif = STAM - startattribute
	if dif > 0 then
		text = "|cFF69FF69"..(STAM - startattribute)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(STAM - startattribute)
	end

	return L["tooltipDescriptionExa"]..L["stamina"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = UnitStat("player", 3) or 0
		STAM = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["stamina"].."|r".." Multi",
	tooltip = L["stamina"],
	icon = "Interface\\Icons\\spell_shadow_bloodboil",
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
