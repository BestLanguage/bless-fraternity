----------------------
-- Levels First Aid --
----------------------
MTSL_DATA["First Aid"]["levels"] = {
	{
		["trainers"] = {
			["price"] = 100,
			["sources"] = {
				2326, -- [1]
				2327, -- [2]
				2329, -- [3]
				2798, -- [4]
				3181, -- [5]
				3373, -- [6]
				4211, -- [7]
				4591, -- [8]
				5150, -- [9]
				5759, -- [10]
				5939, -- [11]
				5943, -- [12]
				6094, -- [13]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["First Aid"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["First Aid"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["First Aid"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["First Aid"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["First Aid"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["First Aid"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["First Aid"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["First Aid"],
		},
		["min_skill"] = 0,
		["id"] = 3273,
		["max_skill"] = 75,
	}, -- [1]
	{
		["trainers"] = {
			["price"] = 500,
			["sources"] = {
				2326, -- [1]
				2327, -- [2]
				2329, -- [3]
				2798, -- [4]
				3181, -- [5]
				3373, -- [6]
				4211, -- [7]
				4591, -- [8]
				5150, -- [9]
				5759, -- [10]
				5939, -- [11]
				5943, -- [12]
				6094, -- [13]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["First Aid"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["First Aid"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["First Aid"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["First Aid"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["First Aid"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["First Aid"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["First Aid"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["First Aid"],
		},
		["min_skill"] = 50,
		["id"] = 3274,
		["max_skill"] = 150,
	}, -- [2]
	{
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["First Aid"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["First Aid"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["First Aid"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["First Aid"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["First Aid"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["First Aid"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["First Aid"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["First Aid"],
		},
		["min_skill"] = 125,
		["id"] = 7924,
		["max_skill"] = 225,
		["item"] = 16084,
	}, -- [3]
	{
		["min_xp_level"] = 35,
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["First Aid"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["First Aid"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["First Aid"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["First Aid"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["First Aid"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["First Aid"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["First Aid"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["First Aid"],
		},
		["min_skill"] = 200,
		["id"] = 10846,
		["quests"] = {
			6622, -- [1]
			6624, -- [2]
		},
		["max_skill"] = 300,
	}, -- [4]
}