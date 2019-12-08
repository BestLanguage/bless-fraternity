--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Melee Power.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_MLAM"
local MP = 0
local startattribute
-----------------------------------------------
local function OnUpdate(self, id)
	local base, posBuff, negBuff = UnitAttackPower("player");
	local meleepower = (base and base + posBuff + negBuff) or 0;

	if MP == meleepower then return end
	MP = meleepower

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (MP - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(MP - startattribute).."]"
		elseif (MP - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(MP - startattribute).."]"
		end
	end

	local MPtext = "|cFFFFFFFF"..MP

	return L["meleepower"]..": ", MPtext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0%")

	local dif = MP - startattribute -- Cores da conta de valor
	if dif > 0 then
		text = "|cFF69FF69"..(MP - startattribute)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(MP - startattribute)
	end

	return L["tooltipDescriptionExa"]..L["meleepower"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = UnitAttackPower("player") or 0
		MP = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["meleepower"].."|r".." Multi",
	tooltip = L["meleepower"],
	icon = "Interface\\Icons\\inv_sword_38.blp",
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
