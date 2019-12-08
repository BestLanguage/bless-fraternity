--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Spell Power.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_SLLM"
local SP = 0
local startattribute
-----------------------------------------------
local function OnUpdate(self, id)
	local base = GetSpellBonusDamage(2);
	local spellpower = base or 0;

	if SP == spellpower then return end
	SP = spellpower

	TitanPanelButton_UpdateButton(id)
	return true
end
-----------------------------------------------
local function GetButtonText(self, id)
	local BarBalanceText = ""
	if TitanGetVar(ID, "ShowBarBalance") then
		if (SP - startattribute) > 0 then
			BarBalanceText = " |cFF69FF69["..(SP - startattribute).."]"
		elseif (SP - startattribute) < 0 then
			BarBalanceText = " |cFFFF2e2e["..(SP - startattribute).."]"
		end
	end

	local SPtext = "|cFFFFFFFF"..SP

	return L["spellpower"]..": ", SPtext..BarBalanceText
end
-----------------------------------------------
local function GetTooltipText(self, id)
	local text = TitanUtils_GetHighlightText("0%")

	local dif = SP - startattribute -- Cores da conta de valor
	if dif > 0 then
		text = "|cFF69FF69"..(SP - startattribute)
	elseif dif < 0 then
		text = "|cFFFF2e2e"..(SP - startattribute)
	end

	return L["tooltipDescriptionExa"]..L["spellpower"].."|r.\r"..L["session"]..text
end
-----------------------------------------------
local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startattribute = GetSpellBonusDamage(2) or 0
		SP = startattribute

		TitanPanelButton_UpdateButton(self.registry.id)
	end
}
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["spellpower"].."|r".." Multi",
	tooltip = L["spellpower"],
	icon = "Interface\\Icons\\spell_nature_lightning.blp",
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
