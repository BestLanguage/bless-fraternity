--------------------
-- Levels Cooking --
--------------------
MTSL_DATA["Cooking"]["levels"] = {
	{
		["trainers"] = {
			["price"] = 100,
			["sources"] = {
				1355, -- [1]
				1382, -- [2]
				1430, -- [3]
				1699, -- [4]
				3026, -- [5]
				3067, -- [6]
				3087, -- [7]
				3399, -- [8]
				4210, -- [9]
				4552, -- [10]
				5159, -- [11]
				5482, -- [12]
				6286, -- [13]
				8306, -- [14]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Cooking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Cooking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Cooking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Cooking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Cooking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Cooking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Cooking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Cooking"],
		},
		["min_skill"] = 0,
		["id"] = 2550,
		["max_skill"] = 75,
	}, -- [1]
	{
		["trainers"] = {
			["price"] = 500,
			["sources"] = {
				1355, -- [1]
				1382, -- [2]
				1430, -- [3]
				1699, -- [4]
				3026, -- [5]
				3067, -- [6]
				3087, -- [7]
				3399, -- [8]
				4210, -- [9]
				4552, -- [10]
				5159, -- [11]
				5482, -- [12]
				6286, -- [13]
				8306, -- [14]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Cooking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Cooking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Cooking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Cooking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Cooking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Cooking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Cooking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Cooking"],
		},
		["min_skill"] = 50,
		["id"] = 3102,
		["max_skill"] = 150,
	}, -- [2]
	{
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Cooking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Cooking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Cooking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Cooking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Cooking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Cooking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Cooking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Cooking"],
		},
		["min_skill"] = 125,
		["id"] = 3413,
		["max_skill"] = 225,
		["item"] = 16072,
	}, -- [3]
	{
		["min_xp_level"] = 35,
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Cooking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Cooking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Cooking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Cooking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Cooking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Cooking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Cooking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Cooking"],
		},
		["min_skill"] = 200,
		["id"] = 18260,
		["quests"] = {
			6610, -- [1]
		},
		["max_skill"] = 300,
	}, -- [4]
}