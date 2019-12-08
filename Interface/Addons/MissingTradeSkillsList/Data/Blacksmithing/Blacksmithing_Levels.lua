--------------------------
-- Levels Blacksmithing --
--------------------------
MTSL_DATA["Blacksmithing"]["levels"] = {
	{
		["trainers"] = {
			["price"] = 10,
			["sources"] = {
				514, -- [1]
				957, -- [2]
				1241, -- [3]
				1383, -- [4]
				2836, -- [5]
				2998, -- [6]
				3174, -- [7]
				3355, -- [8]
				3557, -- [9]
				4258, -- [10]
				4605, -- [11]
				5511, -- [12]
				6299, -- [13]
				10266, -- [14]
				10276, -- [15]
				10277, -- [16]
				10278, -- [17]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
		},
		["min_skill"] = 0,
		["id"] = 2018,
		["max_skill"] = 75,
		["min_xp_level"] = 5,
	}, -- [1]
	{
		["trainers"] = {
			["price"] = 500,
			["sources"] = {
				1383, -- [1]
				2836, -- [2]
				2998, -- [3]
				3136, -- [4]
				3355, -- [5]
				3478, -- [6]
				4258, -- [7]
				4596, -- [8]
				5511, -- [9]
				10276, -- [10]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
		},
		["min_skill"] = 50,
		["id"] = 3100,
		["max_skill"] = 150,
	}, -- [2]
	{
		["trainers"] = {
			["price"] = 5000,
			["sources"] = {
				2836, -- [1]
				3355, -- [2]
				4258, -- [3]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
		},
		["min_skill"] = 125,
		["id"] = 3538,
		["max_skill"] = 225,
	}, -- [3]
	{
		["min_xp_level"] = 35,
		["trainers"] = {
			["price"] = 50000,
			["sources"] = {
				2836, -- [1]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Blacksmithing"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Blacksmithing"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Blacksmithing"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Blacksmithing"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Blacksmithing"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Blacksmithing"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Blacksmithing"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Blacksmithing"],
		},
		["min_skill"] = 200,
		["id"] = 9785,
		["max_skill"] = 300,
	}, -- [4]
}