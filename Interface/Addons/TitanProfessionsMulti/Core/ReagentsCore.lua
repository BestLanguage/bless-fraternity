--[[
	Description: This plugin is part of the "Titan Panel [Professions] Multi" addon.
	Site: http://www.curse.com/addons/wow/titan-panel-professions-multi
	Author: Canettieri
	Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local ACE = LibStub("AceLocale-3.0"):GetLocale("Titan", true)

local function ToggleShowBarBalance(self, id) -- Show Balance in Titan Bar
	TitanToggleVar(id, "ShowBarBalance");
	TitanPanelButton_UpdateButton(id)
end

function L.PrepareReagentsMenu(self, id)
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[id].menuText)
	TitanPanelRightClickMenu_AddToggleIcon(id)

	info = {};
	info.text = L["showbb"];
	info.func = ToggleShowBarBalance;
	info.arg1 = id
	info.checked = TitanGetVar(id, "ShowBarBalance");
	L_UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(ACE["TITAN_PANEL_MENU_HIDE"], id, TITAN_PANEL_MENU_FUNC_HIDE);
end
----------------------------------------------
