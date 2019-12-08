--[[
Description: This plugin is part of the "Titan Panel [Attributes] Multi" addon. It shows your Quests.
Site: http://www.curse.com/addons/wow/titan-panel-attributes-multi
Author: Canettieri
Special Thanks to Eliote.
--]]

local ADDON_NAME, L = ...;
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_QUESSM"
local quests = 0
local count = 0
local maximum = 25
-----------------------------------------------
local function OnClick(self, button)
	if (button == "LeftButton") then
		ToggleFrame(WorldMapFrame);
	end
end
-----------------------------------------------
local function UpdateAll(self)
	local numEntries, numQuests = GetNumQuestLogEntries();

	quests = numQuests
	count = 0

	for questIndex = 1, numEntries do
	    local title, level, suggestedGroup, isHeader, isCollapsed, isComplete = GetQuestLogTitle(questIndex)
	    if(isComplete) then count = count + 1 end
	end

	TitanPanelButton_UpdateButton(self.registry.id)
end
-----------------------------------------------
local eventsTable = {
	UNIT_QUEST_LOG_CHANGED = UpdateAll;
	PLAYER_ENTERING_WORLD = UpdateAll; -- Jogador entra no Mundo
--	QUEST_COMPLETE = UpdateAll;
--	QUEST_ACCEPTED = UpdateAll;
--  QUEST_FINISHED = UpdateAll;
	QUEST_LOG_UPDATE = UpdateAll;
--	QUEST_LOG_UPDATE = function(self) self:UnregisterEvent("QUEST_LOG_UPDATE"); UpdateAll(self) end
}
-----------------------------------------------
local function GetButtonText(self, id)

	local completedtext
	if quests > 15 and quests < 20 then
		completedtext = "|cFFf6ed12"..quests
	elseif quests > 19 and quests < 25 then
		completedtext = "|cFFf69112"..quests
	elseif quests == 25 then
		completedtext = "|cFFFF2e2e"..quests
	else
		completedtext = TitanUtils_GetHighlightText(quests)
	end

	return L["quests"]..": ", "|cFFFFFFFF[|r|cFF69FF69"..count.."|r|cFFFFFFFF]|r "..completedtext.."|||cFFFF2e2e"..maximum
end
-----------------------------------------------
local function GetTooltipText(self, id)

	return L["hintquest"]..L["compquest"]..count.."|r\r"..L["numquests"]..quests.."|r\r"..L["maxquests"]..maximum
end
-----------------------------------------------
L.Elib({
	id = ID,
	name = "Titan|cFFf9251a "..L["quests"].."|r".." Multi",
	tooltip = L["quests"],
	icon = "Interface\\Icons\\inv_misc_book_03",
	category = "Information",
	version = version,
	eventsTable = eventsTable,
	onClick = OnClick,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	prepareMenu = L.PrepareAttributesMenu,
	savedVariables = {
		ShowIcon = 1,
		DisplayOnRightSide = false,
		ShowBarBalance = false,
		ShowLabelText = false,
	},
})
