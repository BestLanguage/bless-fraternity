--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your XP.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local ACE = LibStub("AceLocale-3.0"):GetLocale("Titan", true)
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_XPRCTM"
local AXP
local MXP
local PERC
local LVL
local EXXP
local CHARCOLOR = "|c" .. RAID_CLASS_COLORS[select(2, UnitClass("player"))].colorStr
-----------------------------------------------
local function UpdateAll(self)

	local restState   = GetRestState();
  local pXP, pMaxXP = UnitXP("player"), UnitXPMax("player");
  local rPos = (pXP / pMaxXP) * 100;
	local level = UnitLevel("player")
	local exhaustionXP = GetXPExhaustion()

	AXP = pXP
	MXP = pMaxXP
	PERC = rPos
	LVL = level
	EXXP = exhaustionXP or 0

	TitanPanelButton_UpdateButton(self.registry.id)
end
-----------------------------------------------
local eventsTable = {
	PLAYER_XP_UPDATE = UpdateAll,
	PLAYER_ENTERING_WORLD = UpdateAll, -- Jogador entra no Mundo
	PLAYER_UPDATE_RESTING = UpdateAll,
	PLAYER_LEVEL_UP = UpdateAll,
}
-----------------------------------------------
local function GetButtonText(self, id)

	if LVL < 60 then
		local toUp = MXP - AXP
		local restperc = (EXXP / ((MXP / 100) * 1.5))


		local XPrest = "   |TInterface\\Icons\\spell_nature_sleep:0|t |cFFFFFFFF[|r|cffe6cc80"..(string.format("%.1f", restperc)).."%|r|cFFFFFFFF] "..(formatNumber(EXXP, '.'))
		if TitanGetVar(id, "HideRest") or EXXP == 0 then
			XPrest = ""
		end

		local XPtext = "|cFFFFFFFF[|r"..CHARCOLOR..LVL.."|cFFFFFFFF]|r|cFF69FF69 "..(formatNumber(AXP, '.')).."|r|||cFFFFFFFF"..(formatNumber(MXP, '.')).." |cFFFF2e2e("..(formatNumber(toUp, '.'))..")|r |cFFFFFFFF[|cFF69FF69"..(string.format("%.1f", PERC)).."%|r|cFFFFFFFF]"

		local Btext = XPtext..XPrest
		if TitanGetVar(id, "SimpleText") then
			Btext = "|cFF69FF69 "..(formatNumber(AXP, '.')).."|r|||cFFFFFFFF"..(formatNumber(MXP, '.')).." |cFFFFFFFF[|cFF69FF69"..(string.format("%.1f", PERC)).."%|r|cFFFFFFFF] "
		end

		return L["xp"]..": ", Btext

	else
		return L["xp"]..": ", "|cFFFFFFFF[|r"..CHARCOLOR..LVL.."|cFFFFFFFF]|cFF69FF69 "..L["maxlvl"]
	end
end
-----------------------------------------------
local function GetTooltipText(self, id)
	if LVL < 60 then
		local toUp = MXP - AXP
		local restperc = (EXXP / ((MXP / 100) * 1.5))

		local AXPttp = L["actualXP"]..(formatNumber(AXP, '.')).."|r\r"
		local MXPttp = L["needXP"]..(formatNumber(MXP, '.')).."|r\r"
		local toUpttp = L["XPtoUp"]..(formatNumber(toUp, '.')).."|r\r"
		local PERCttp = L["percentage"]..(string.format("%.1f", PERC)).."%|r"
		local EXXPttp = L["restxp"]..(formatNumber(EXXP, '.')).."|r\r"
		local PERCRttp = L["restprogr"]..(string.format("%.1f", restperc)).."%"

		local restInttp = "\r\r"..L["restttp"]..EXXPttp..PERCRttp
		if EXXP == 0 then
			restInttp = ""
		end

		local ttpText = AXPttp..MXPttp..toUpttp..PERCttp..restInttp

		return ttpText

	else
		return L["maxttp"]
	end
end
-----------------------------------------------
local function PrepareMenu(self, id)
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[id].menuText)
	TitanPanelRightClickMenu_AddToggleIcon(id)
	TitanPanelRightClickMenu_AddToggleLabelText(id)

	local info = UIDropDownMenu_CreateInfo();
	info.text = L["simpleText"];
	info.func = function() TitanToggleVar(id, "SimpleText"); TitanPanelButton_UpdateButton(id); end
	info.checked = TitanGetVar(id, "SimpleText");
	L_UIDropDownMenu_AddButton(info);

	local info = UIDropDownMenu_CreateInfo();
	info.text = L["hiderest"];
	info.func = function() TitanToggleVar(id, "HideRest"); TitanPanelButton_UpdateButton(id); end
	info.checked = TitanGetVar(id, "HideRest");
	L_UIDropDownMenu_AddButton(info);

	local info = UIDropDownMenu_CreateInfo();
	info.text = ACE["TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE"];
	info.func = function() TitanToggleVar(id, "DisplayOnRightSide"); TitanPanel_InitPanelButtons(id); end
	info.checked = TitanGetVar(id, "DisplayOnRightSide");
	L_UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer()
	TitanPanelRightClickMenu_AddCommand(ACE["TITAN_PANEL_MENU_HIDE"], id, TITAN_PANEL_MENU_FUNC_HIDE);
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["xp"].."|r".." Multi",
	tooltip = L["xp"],
	icon = "Interface\\Icons\\inv_drink_08",
	category = "Information",
	version = version,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	eventsTable = eventsTable,
	prepareMenu = PrepareMenu,
	savedVariables = {
		ShowIcon = 1,
		DisplayOnRightSide = false,
		SimpleText = false,
		HideRest = false,
		ShowLabelText = false,
	},
})
