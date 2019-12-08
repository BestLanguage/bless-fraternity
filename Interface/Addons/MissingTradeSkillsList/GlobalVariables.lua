-- DEBUGGING PURPOSES
MTSLUI_DEBUG = print

----------------------------------
-- Creates all global variables --
----------------------------------

-- Holds all the data filled by the data luas
MTSL_DATA = {
	-- Primary Professions (no skinning, herbalism because they don't have a tradeskillframe)
	["Alchemy"] = {},
	["Blacksmithing"] = {},
	["Enchanting"] = {},		-- craft
	["Engineering"] = {},
	["Leatherworking"] = {},
	["Mining"] = {},
	["Tailoring"] = {},
	-- Secundary professions (no fishing because it doesn't have atradeskillframe)
	["Cooking"] = {},
	["First Aid"] = {},
	-- all game items/objects we need in 1 array
	["Objects"] = {},
	["NPCs"] = {},
	["Quests"] = {},
	-- Each profession has 4 levels to learn (1-75, 75-150, 150-225, 225-300)
	TRADESKILL_LEVELS = 4,
	-- Counters keeping track of total amount of items (so we dont have to count each time)
	AMOUNT_ITEMS = {
		["Alchemy"] = 71,
		["Blacksmithing"] = 156,
		["Enchanting"] = 87,		-- craft
		["Engineering"] = 80,
		["Leatherworking"] = 153,
		["Mining"] = 0,
		["Tailoring"] = 138,
		-- Secundary professions (no fishing because it doesn't have a tradeskillframe)
		["Cooking"] = 71,
		["First Aid"] = 5,
	},
	AMOUNT_SKILLS = {
		["Alchemy"] = 111,
		["Blacksmithing"] = 249,
		["Enchanting"] = 151,		-- craft
		["Engineering"] = 167,
		["Leatherworking"] = 235,
		["Mining"] = 12,
		["Tailoring"] = 225,
		-- Secondary professions (no fishing because it doesn't have a tradeskillframe)
		["Cooking"] = 81,
		["First Aid"] = 13,
	},
	AMOUNT_OBJECTS = {
		["NPCs"] = 609,
		["Objects"] = 3,
		["Quests"] = 85,
		["Zones"] = 82,
        ["Factions"] = 54,
	}
}

-- holds all info about the addon itself
MTSL_ADDON = {
	AUTHOR = "Thumbkin",
	NAME = "Missing TradeSkills List",
	VERSION = "1.13.14",
}

-- Holds info about the current logged in player
-- Contains following info once loaded from data
--		NAME,
--		FACTION,
--		REALM,
--		XP_LEVEL,
--		TRADESKILLS = {}
MTSL_CURRENT_PLAYER = {}

-- Holds information on the opened trade skill
-- Contains following info once loaded from player
-- 		NAME,
-- 		SKILL_LEVEL,
-- 		MAX_LEVEL,
-- 		AMOUNT_LEARNED,
-- 		AMOUNT_MISSING,
-- 		MISSING_SKILLS,	-- holds the ids of the missing skills
-- 		SPELLID_HIGHEST_KNOWN_RANK, -- holds the id of the spell of the highest known rank (Apprentice, Journeyman, Expert or Artisan)
MTSL_CURRENT_TRADESKILL = {}

-- Use seperate variable to link to the missing skills
-- We dont want to save full info of each skill with the char, ids will do
MTSL_MISSING_TRADESKILLS = {}

--- holds the icons of the professions
MTSL_ICONS_PROFESSION = {
	["Alchemy"] = "136240",
	["Blacksmithing"] = "136241",
	["Enchanting"] = "136244",		-- craft
	["Engineering"] = "136243",
	["Leatherworking"] = "133611",
	["Mining"] = "136248",
	["Tailoring"] = "136249",
	-- Secondary professions (no fishing because it doesn't have a tradeskillframe)
	["Cooking"] = "133971",
	["First Aid"] = "135966",
}

-- array holding all reputation levels
MTSL_REPUTATION_LEVELS = {
	["Unknown"] = 0,
	["Hated"] = 1,
	["Hostile"] = 2,
	["Unfriendly"] = 3,
	["Neutral"] = 4,
	["Friendly"] = 5,
	["Honored"] = 6,
	["Revered"] = 7,
	["Exalted"] = 8
}

----------------------------------
-- Creates all saved variables --
----------------------------------
MTSL_PLAYERS = {}
MTSL_SCALE_UI = nil