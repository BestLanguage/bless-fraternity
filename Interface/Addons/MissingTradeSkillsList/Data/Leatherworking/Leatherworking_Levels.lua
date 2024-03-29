---------------------------
-- Levels Leatherworking --
---------------------------
MTSL_DATA["Leatherworking"]["levels"] = {
	{
		["trainers"] = {
			["price"] = 10,
			["sources"] = {
				223, -- [1]
				1466, -- [2]
				1632, -- [3]
				3008, -- [4]
				3069, -- [5]
				3549, -- [6]
				3605, -- [7]
				5784, -- [8]
				5811, -- [9]
				7866, -- [10]
				7867, -- [11]
				7868, -- [12]
				7869, -- [13]
				7870, -- [14]
				11083, -- [15]
				11096, -- [16]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Leatherworking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Leatherworking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Leatherworking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Leatherworking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Leatherworking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Leatherworking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Leatherworking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Apprentice"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Leatherworking"],
		},
		["min_skill"] = 0,
		["id"] = 2108,
		["max_skill"] = 75,
		["min_xp_level"] = 5,
	}, -- [1]
	{
		["trainers"] = {
			["price"] = 500,
			["sources"] = {
				1385, -- [1]
				3365, -- [2]
				3703, -- [3]
				3967, -- [4]
				4588, -- [5]
				5127, -- [6]
				5564, -- [7]
				7866, -- [8]
				7867, -- [9]
				7868, -- [10]
				7869, -- [11]
				7870, -- [12]
				8153, -- [13]
				11081, -- [14]
				11084, -- [15]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Leatherworking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Leatherworking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Leatherworking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Leatherworking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Leatherworking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Leatherworking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Leatherworking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Journeyman"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Leatherworking"],
		},
		["min_skill"] = 50,
		["id"] = 3104,
		["max_skill"] = 150,
	}, -- [2]
	{
		["trainers"] = {
			["price"] = 5000,
			["sources"] = {
				3007, -- [1]
				4212, -- [2]
				7870, -- [3]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Leatherworking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Leatherworking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Leatherworking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Leatherworking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Leatherworking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Leatherworking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Leatherworking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Expert"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Leatherworking"],
		},
		["min_skill"] = 125,
		["id"] = 3811,
		["max_skill"] = 225,
	}, -- [3]
	{
		["min_xp_level"] = 35,
		["trainers"] = {
			["price"] = 50000,
			["sources"] = {
				7870, -- [1]
				11097, -- [2]
				11098, -- [3]
			},
		},
		["name"] = {
			["German"] = MTSL_LOCALES_PROFESSION_RANKS["German"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["German"]["Leatherworking"],
			["Spanish"] = MTSL_LOCALES_PROFESSION_RANKS["Spanish"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Spanish"]["Leatherworking"],
			["Russian"] = MTSL_LOCALES_PROFESSION_RANKS["Russian"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Russian"]["Leatherworking"],
			["Portuguese"] = MTSL_LOCALES_PROFESSION_RANKS["Portuguese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Portuguese"]["Leatherworking"],
			["French"] = MTSL_LOCALES_PROFESSION_RANKS["French"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["French"]["Leatherworking"],
			["English"] = MTSL_LOCALES_PROFESSION_RANKS["English"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["English"]["Leatherworking"],
			["Korean"] = MTSL_LOCALES_PROFESSION_RANKS["Korean"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Korean"]["Leatherworking"],
			["Chinese"] = MTSL_LOCALES_PROFESSION_RANKS["Chinese"]["Artisan"] .. " " .. MTSL_LOCALES_PROFESSIONS["Chinese"]["Leatherworking"],
		},
		["min_skill"] = 200,
		["id"] = 10662,
		["max_skill"] = 300,
	}, -- [4]
}