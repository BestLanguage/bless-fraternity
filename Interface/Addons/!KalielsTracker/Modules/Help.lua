--- Kaliel's Tracker
--- Copyright (c) 2012-2019, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_Help")
KT.Help = M

local T = LibStub("MSA-Tutorials-1.0")
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db, dbChar
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local helpPath = mediaPath.."Help\\"
local helpName = "help"
local helpNumPages = 7
local cTitle = "|cffffd200"
local cBold = "|cff00ffe3"
local cNew = "|cff00ff00"
local cWarning = "|cffff7f00"
local cDots = "|cff808080"
local offs = "\n|T:1:8|t"
local beta = "|cffff7fff[Beta]|r"

local KTF = KT.frame

--------------
-- Internal --
--------------

local function AddonInfo(name)
	local info = "\nAddon "..name
	if IsAddOnLoaded(name) then
		info = info.." |cff00ff00is installed|r. Support you can enable/disable in Options."
	else
		info = info.." |cffff0000is not installed|r."
	end
	return info
end

local function SetupTutorials()
	T.RegisterTutorial(helpName, {
		savedvariable = KT.db.global,
		key = "helpTutorial",
		title = KT.title.." |cffffffffv"..KT.version.."|r",
		icon = helpPath.."KT_logo",
		font = "Fonts\\FRIZQT__.TTF",
		width = 552,
		imageHeight = 256,
		{	-- 1
			image = helpPath.."help_kaliels-tracker",
			text = cTitle..KT.title.." (Classic)|r adds some features from Retail build to WoW Classic.\n"..
					"It will be released as a separated project. Images inside this Help are from Retail build of "..KT.title..".\n\n"..
					"Some features:\n"..
					"- Change tracker position\n"..
					"- Expand / Collapse tracker relative to selected position (direction)\n"..
					"- Auto set trackers height by content with max. height limit\n"..
					"- Scrolling when content is greater than max. height\n"..
					"- Remember collapsed tracker after logout/exit game\n\n"..
					"... and many other enhancements (see next pages).",
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 2
			image = helpPath.."help_header-buttons",
			imageHeight = 128,
			text = cTitle.."Header buttons|r\n\n"..
					"Minimize button:                                Other buttons:\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:0:14:0:14:209:170:0|t "..cDots.."...|r Expand Tracker                          "..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:3:-1:32:64:16:30:0:14:209:170:0|t  "..cDots.."...|r Open Quest Log\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:0:14:16:30:209:170:0|t "..cDots.."...|r Collapse Tracker                        "..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:3:-1:32:64:16:30:32:46:209:170:0|t  "..cDots.."...|r Open Filters menu\n"..
					"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:0:14:32:46:209:170:0|t "..cDots.."...|r when is tracker empty\n\n"..
					"Button |T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:16:30:0:14:209:170:0|t "..
					"you can disable in Options.\n\n"..
					"You can set "..cBold.."[key bind]|r for Minimize button.\n"..
					cBold.."Alt+Click|r on Minimize button opens "..KT.title.." Options.",
			textY = 16,
			shine = KTF.MinimizeButton,
			shineTop = 13,
			shineBottom = -14,
			shineRight = 16,
		},
		{	-- 3
			image = helpPath.."help_quest-title-tags",
			imageHeight = 128,
			text = cTitle.."Quest title tags|r\n\n"..
					"At the start of quest titles you see tags like this |cffff8000[100|cff00b3ffhc!|cffff8000]|r.\n\n"..
					"|cff00b3ff!|r|T:14:3|t "..cDots..".......|r Daily quest|T:14:121|t|cff00b3ffr|r "..cDots..".......|r Raid quest\n"..
					"|cff00b3ff!!|r "..cDots.."......|r Weekly quest|T:14:108|t|cff00b3ffr10|r "..cDots.."...|r 10-man raid quest\n"..
					"|cff00b3ffg3|r "..cDots..".....|r Group quest w/ group size|T:14:25|t|cff00b3ffr25|r "..cDots.."...|r 25-man raid quest\n"..
					"|cff00b3ffpvp|r "..cDots.."...|r PvP quest|T:14:133|t|cff00b3ffs|r "..cDots..".......|r Scenario quest\n"..
					"|cff00b3ffd|r "..cDots..".......|r Dungeon quest|T:14:97|t|cff00b3ffa|r "..cDots..".......|r Account quest\n"..
					"|cff00b3ffhc|r "..cDots..".....|r Heroic quest|T:14:113|t|cff00b3ffleg|r "..cDots.."....|r Legendary quest\n\n"..
					cWarning.."Note:|r Not all these tags are used in Classic.",
			shineTop = 10,
			shineBottom = -9,
			shineLeft = -12,
			shineRight = 10,
		},
		{	-- 4
			image = helpPath.."help_tracker-filters",
			text = cTitle.."Tracker Filters|r\n\n"..
					"For open Filters menu "..cBold.."Click|r on the button |T"..mediaPath.."UI-KT-HeaderButtons:14:14:-2:-1:32:64:16:30:32:46:209:170:0|t.\n\n"..
					"There are two types of filters:\n"..
					cTitle.."Static filter|r - adds quests to tracker by criterion (e.g. \"Daily\") and then you can add/remove items by hand.\n"..
					cTitle.."Dynamic filter|r - automatically adding quests to tracker by criterion (e.g. \"|cff00ff00Auto|r Zone\") "..
					"and continuously changing them. This type doesn't allow add/remove items by hand."..
					"When is some Dynamic filter active, header button is green |T"..mediaPath.."UI-KT-HeaderButtons:14:14:-2:-1:32:64:16:30:32:46:0:255:0|t.\n\n"..
					"This menu displays other options affecting the content of the tracker.",
			textY = 16,
			shine = KTF.FilterButton,
			shineTop = 10,
			shineBottom = -11,
			shineLeft = -10,
			shineRight = 11,
		},
		{	-- 5
			image = helpPath.."help_tracker-modules",
			text = cTitle.."Order of Modules|r\n\n"..
					"Allows to change the order of modules inside the tracker. Supports all modules including external (e.g. PetTracker).\n\n"..
					cWarning.."Note:|r In Classic is not yet in use.",
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 6
			image = helpPath.."help_quest-log",
			text = cTitle.."Quest Log|r\n\n"..
					cWarning.."Note:|r In Blizzard's Quest Log and supported Quest Log addons is disabled click on Quest Log "..
					"headers (for collapse / expand). This is because collapsed sections hide contained quests for "..KT.title..".\n\n"..

					cTitle.."Supported addons|r\n"..
					"- Classic Quest Log"..
					offs..cBold.."https://www.wowinterface.com/downloads/info24937-Classic"..
					offs.."QuestLogforClassic.html|r\n"..
					"- QuestGuru"..
					offs..cBold.."https://www.curseforge.com/wow/addons/questguru_classic|r\n"..
					"- QuestLogEx"..
					offs..cBold.."https://www.wowinterface.com/downloads/info24980-QuestLogEx.html|r",
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 7
			text = cTitle.."         What's NEW in version |cffffffff0.1.2|r\n\n"..
					"- FIXED - ticket #17 - SetPoint trying to anchor to itself - Blizzard's quests data"..
					offs.."not loaded (e.g. cache is empty)\n"..
					"- FIXED - ticket #20 - Quest notification sound spams on every sub-zone"..
					offs.."transfer\n"..
					"- FIXED - failed Quest with timer cause error when repeatedly picked up\n"..
					"- ADDED - zone name to tracked quests (bellow quest name, inside tooltip)\n"..
					"- ADDED - Filters - Sorting - by Level, by Level (reversed), Completed at top,"..
					offs.."Completed at bottom\n"..
					"- ADDED - Compatibility - addons QuestGuru and Classic Quest Log\n"..
					"- ADDED / CHANGED - Objective numbers at the beginning of a line\n"..
					"- IMPROVED - Zone filtering - better quest selection for zone, always displayed"..
					offs.."class quests\n"..
					"- UPDATED - Wowhead Classic URL\n"..
					"- UPDATED - support for ElvUI v1.07 and Tukui v1.20\n"..
					"- UPDATED - Libs\n"..
					"- Some other improvements\n\n"..

					cTitle.."Issue reporting|r\n"..
					"For reporting please use "..cBold.."Tickets|r instead of Comments on CurseForge.\n\n\n\n"..

					cWarning.."Before reporting of errors, please deactivate other addons and make sure the bug is not caused "..
					"by a collision with another addon.|r",
			textY = -20,
			editbox = "https://www.curseforge.com/wow/addons/kaliels-tracker-classic/issues",
			editboxWidth = 450,
			editboxBottom = 40,
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		onShow = function(self, i)
			if dbChar.collapsed then
				ObjectiveTracker_MinimizeButton_OnClick()
			end
			if i == 2 then
				if KTF.FilterButton then
					self[i].shineLeft = db.hdrOtherButtons and -55 or -35
				else
					self[i].shineLeft = db.hdrOtherButtons and -35 or -15
				end
			elseif i == 3 then
				local questInfo = KT_GetQuestListInfo(1)
				if questInfo then
					local block = QUEST_TRACKER_MODULE.usedBlocks[questInfo.id]
					if block then
						self[i].shine = block
					end
				end
			end
		end
	})
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	db = KT.db.profile
	dbChar = KT.db.char
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	SetupTutorials()
	local last = false
	if KT.version ~= KT.db.global.version then
		local data = T.GetTutorial(helpName)
		local index = data.savedvariable[data.key]
		if index then
			last = index < helpNumPages and index or true
			T.ResetTutorial(helpName)
		end
	end
	T.TriggerTutorial(helpName, helpNumPages, last)
end

function M:ShowHelp(index)
	InterfaceOptionsFrame:Hide()
	T.ResetTutorial(helpName)
	T.TriggerTutorial(helpName, helpNumPages, index or false)
end