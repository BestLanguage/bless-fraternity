-----------------------
-- Levels Enchanting --
-----------------------
MTSL_DATA["Enchanting"]["levels"] = {
	{
		["trainers"] = {
			["price"] = 10,
			["sources"] = {
				1317, -- [1]
				3011, -- [2]
				3345, -- [3]
				3606, -- [4]
				4616, -- [5]
				5157, -- [6]
				5695, -- [7]
				7949, -- [8]
				11065, -- [9]
				11066, -- [10]
				11067, -- [11]
				11068, -- [12]
				11070, -- [13]
				11071, -- [14]
				11072, -- [15]
				11073, -- [16]
				11074, -- [17]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Enchanting"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Enchanting"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Enchanting"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Enchanting"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Enchanting"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Enchanting"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Enchanting"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Enchanting"],
		},
		["min_skill"] = 0,
		["id"] = 7411,
		["max_skill"] = 75,
		["min_xp_level"] = 5,
	}, -- [1]
	{
		["trainers"] = {
			["price"] = 500,
			["sources"] = {
				1317, -- [1]
				3011, -- [2]
				3345, -- [3]
				4213, -- [4]
				4616, -- [5]
				5157, -- [6]
				7949, -- [7]
				11072, -- [8]
				11073, -- [9]
				11074, -- [10]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Enchanting"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Enchanting"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Enchanting"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Enchanting"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Enchanting"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Enchanting"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Enchanting"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Enchanting"],
		},
		["min_skill"] = 50,
		["id"] = 7412,
		["max_skill"] = 150,
	}, -- [2]
	{
		["trainers"] = {
			["price"] = 5000,
			["sources"] = {
				11072, -- [1]
				11073, -- [2]
				11074, -- [3]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Enchanting"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Enchanting"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Enchanting"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Enchanting"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Enchanting"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Enchanting"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Enchanting"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Enchanting"],
		},
		["min_skill"] = 125,
		["id"] = 7413,
		["max_skill"] = 225,
	}, -- [3]
	{
		["min_xp_level"] = 35,
		["trainers"] = {
			["price"] = 50000,
			["sources"] = {
				11073, -- [1]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Enchanting"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Enchanting"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Enchanting"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Enchanting"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Enchanting"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Enchanting"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Enchanting"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Enchanting"],
		},
		["min_skill"] = 200,
		["id"] = 13920,
		["max_skill"] = 300,
	}, -- [4]
}