-------------------------------------------------
-- Contains all shared functions for the logic --
-------------------------------------------------
MTSL_TOOLS = {
	---------------------------------------------------------------------------------------
	-- Loads the saved data of the logged in player or creates a new save
	-- Triggerd by game event "PLAYER_LOGIN"
	---------------------------------------------------------------------------------------
    LoadPlayer = function (self)
        local name = UnitName("player")
		local realm = GetRealmName()
        local faction = UnitFactionGroup("player")
        local xp_level = UnitLevel("player")

		if name == nil or realm == nil or
				faction == nil or xp_level == nil then
			print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not load player info! Try reloading this addon")
		end

    	local current_player = MTSL_PLAYERS[realm]
		-- Realm not yet registered so create it
		if current_player == nil then
			MTSL_PLAYERS[realm] = {}
		-- Realm exists, so see if we have saved the char already
		else
			current_player = MTSL_PLAYERS[realm][name]
		end

    	-- Player not found on realm, so save him
    	if current_player == nil then
    	    -- Not found so create a new one
    	    current_player = {
				NAME = name,
				REALM = realm,
				FACTION = faction,
				XP_LEVEL = xp_level,
				TRADESKILLS = {},
			}
			-- Get additional player info to save
			print(MTSLUI_FONTS.COLORS.TEXT.WARNING .. "MTSL: Saving new player. Please open all profession windows to save skills")
			-- new player added so sort the table (first the realms, then for new realm, sort by name
			MTSL_PLAYERS[realm][name] = current_player
			table.sort(MTSL_PLAYERS, function(a, b) return a < b end)
			table.sort(MTSL_PLAYERS[realm], function(a, b) return a.name < b.name end)
		else
			print(MTSLUI_FONTS.COLORS.TEXT.SUCCESS .. "MTSL: Player " .. current_player.NAME .. " (" .. current_player.XP_LEVEL .. ", " .. current_player.FACTION .. ") on " .. current_player.REALM .. " loaded")
    	end
    	-- set the loaded or created player as current one
    	MTSL_CURRENT_PLAYER = current_player
    	-- Update faction & xp_level, just in case
        MTSL_CURRENT_PLAYER.XP_LEVEL = xp_level
        MTSL_CURRENT_PLAYER.FACTION = faction
    end,

	---------------------------------------------------------------------------------------
	-- Conver a number to xx g xx s xx c
	--
	-- @money_number:	number		The amount expressed in coppers (e.g.: 10000 = 1g 00 s 00c)
	--
	-- returns			String		Number converted to xx g xx s xx c
	----------------------------------------------------------------------------------------
	GetNumberAsMoneyString = function (self, money_number)
		if type(money_number) ~= "number" then
			return "-"
		end

		-- Calculate the amount of gold, silver and copper
		local gold = floor(money_number/10000)
		local silver = floor(mod((money_number/100),100))
		local copper = mod(money_number,100)

		local money_string = ""
		-- Add gold if we have
		if gold > 0 then
			money_string = money_string .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. gold .. MTSLUI_FONTS.COLORS.MONEY.GOLD .. "g "
		end
		-- Add silver if we have
		if silver > 0 then
			money_string = money_string .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. silver .. MTSLUI_FONTS.COLORS.MONEY.SILVER .. "s "
		end
		-- Always show copper even if 0
		money_string = money_string .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. copper .. MTSLUI_FONTS.COLORS.MONEY.COPPER .. "c"

		return money_string
	end,

	----------------------------------------------------------------------------------------------------------
	-- Checks if all data is present and correctly loaded in the addon
	--
	-- returns		Boolean		Flag indicating if data is valid
	----------------------------------------------------------------------------------------------------------
	CheckIfDataIsValid = function(self)
		-- check the professions
		local prof_to_check = { "Alchemy", "Blacksmithing", "Enchanting", "Engineering", "Leatherworking", "Mining", "Tailoring", "Cooking", "First Aid" }
		local prof_subitems_to_check = { "skills", "levels", "items" }
		local langs_to_check = { "French", "English", "German", "Russian", "Spanish", "Portuguese" }
		for k, v in pairs(prof_to_check) do
			-- profession not present
			if MTSL_DATA[v] == nil then
				print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Could not load all the data needed for the addon! Missing profession " .. v .. ". Please reinstall the addon!")
				return false
			end
			for l, w in pairs(prof_subitems_to_check) do
				-- subset not present
				if MTSL_DATA[v][w] == nil then
					print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Could not load all the data needed for the addon! Missing " .. w .. " in profession " .. v .. ". Please reinstall the addon!")
					return false
				end
				-- loop each subset
				for m, x in pairs(MTSL_DATA[v][w]) do
					-- check for each translation in the item
					for n, z in pairs(langs_to_check) do
					-- name not translated to a language not present
						if x.name == nil or x["name"][z] == nil then
							print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Could not load all the data needed for the addon! Missing translation for " .. w .. " with id " .. x.id .. " in profession " .. v .. ". Please reinstall the addon!")
							return false
						end
					end
				end
			end
		end
		-- check the NPCs, objets & quests
		local objects_to_check = { "npcs", "objects", "quests", "zones", "factions", "continents" }
		for k, v in pairs(prof_to_check) do
			-- object not present
			if MTSL_DATA[v] == nil then
				print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Could not load all the data needed for the addon! Missing " .. v .. ". Please reinstall the addon!")
				return false
			end
		end

		return true
	end,

	----------------------------------------------------------------------------------------------------------
	-- Creates a deep copy of an object
	--
	-- @orig		Object		The original object to copy
	--
	-- returns		Object		A copy of the original object
	----------------------------------------------------------------------------------------------------------
	CopyObject = function (self, orig)
		local orig_type = type(orig)
		local copy
		if orig_type == 'table' then
			copy = {}
			for orig_key, orig_value in next, orig, nil do
				copy[self:CopyObject(orig_key)] = self:CopyObject(orig_value)
			end
			setmetatable(copy, self:CopyObject(getmetatable(orig)))
		else -- number, string, boolean, etc
			copy = orig
		end
		return copy
	end,

	----------------------------------------------------------------------------------------------------------
	-- Searches for an item by id in an unsorted list
	--
	-- @list		Array		The lsit in which to search
	-- @id			Number		The id to search for
	--
	-- returns		Object		The item with the corresponding id or nil if not found
	----------------------------------------------------------------------------------------------------------
	GetItemFromUnsortedListById = function(self, list, id)
		local i = 1
		-- lists are sorted on id (low to high)
		while list[i] ~= nil and list[i].id ~= id do
			i = i + 1
		end

		return list[i]
	end,

	----------------------------------------------------------------------------------------------------------
	-- Searches for an item by id in a sorted list
	--
	-- @list		Array		The lsit in which to search
	-- @id			Number		The id to search for
	--
	-- returns		Object		The item with the corresponding id or nil if not found
	----------------------------------------------------------------------------------------------------------
	GetItemFromSortedListById = function(self, list, id)
		local i = 1
		-- lists are sorted on id (low to high) so stop when id in array >= id we search
		while list[i] ~= nil and list[i].id < id do
			i = i + 1
		end
		-- item found in list so return it
		if list[i] ~= nil and list[i].id == id then
			return list[i]
		end
		-- item not found in the list
		return nil
	end,

	----------------------------------------------------------------------------------------------------------
	-- Counts the number of elements in the list
	--
	-- @list		Array		The list to count items from
	--
	-- returns		Number		The amount of items
	----------------------------------------------------------------------------------------------------------
	CountItemsInArray = function(self, list)
		if list == nil then
			return 0
		end
		local i = 1
		while list[i] ~= nil do
			i = i + 1
		end
		return (i - 1)
	end,

	---------------------------------------------------------------------------------------
	-- Print out an array to the chatframe (DEBUG/DEVELOP only)
	--
	-- @array:			array		The array to show
	---------------------------------------------------------------------------------------
	-- Prints out all info on a skill (DEBUGGING)
	PrintArray = function (self, array)
		if array == nil then
			print("Array is empty")
		else
			for i in pairs(array) do
				if type(array[i]) == "table" then
					print("SubArray " .. i)
					self:PrintArray(array[i])
				elseif i ~= nil and array[i] ~= nil then
					print(i .. ": " .. array[i])
				end
			end
		end
	end,

	---------------------------------------------------------------------------------------
	-- Print out an array to the chatframe (DEBUG/DEVELOP only)
	--
	-- @array:			array		The array to show
	---------------------------------------------------------------------------------------
	-- Prints out all info on a skill (DEBUGGING)
	PrintArrayWithNamedIndex = function (self, array)
		if array == nil then
			print("Array is empty")
		else
			for k, v in pairs(array) do
				if type(v) == "table" then
					print("SubArray " .. k)
					self:PrintArrayWithNamedIndex(v)
				elseif type(v) == "userdata" then
					print(k .. ": " .. type(v))
				elseif k ~= nil and v ~= nil then
					print(k .. ": " .. v)
				end
			end
		end
	end,

	---------------------------------------------------------------------------------------
	-- Gets the number of total skills for a Tradeskill
	--
	-- return		number		Total skills to be  learned for the tradeskill
	---------------------------------------------------------------------------------------
	GetTotalNumberOfSkillsCurrentTradeskill = function(self)
		return MTSL_DATA.AMOUNT_SKILLS[MTSL_CURRENT_TRADESKILL.NAME]
	end,

	----------------------------------------------------------------------------------------
	-- Gives the level of the standing (0-8) with a certain faction
	--
	-- @faction_name	String		The name of the faction
	--
	-- return			number		The standing with the rep (0-8) for the faction
	-----------------------------------------------------------------------------------------
	GetReputationLevelWithFaction = function (self, faction_name)
		for factionIndex = 1, GetNumFactions() do
			local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith,
			canToggleAtWar, isHeader = GetFactionInfo(factionIndex)
			-- check if localised
			if (isHeader == nil or isHeader == false) and name == faction_name then
				return standingId
			end
		end
		-- Not found so return 0 = "Unknown"
		return 0
	end,

	----------------------------------------------------------------------------------------
	-- Gives the name of the replevel based on the standing (0-8)
	--
	-- @rep_id		number		The standing with the rep (0-8)
	--
	-- return		String		The name of the replevel
	-----------------------------------------------------------------------------------------
	GetReputationLevelNameById = function (self, rep_id)
		for k, v in pairs(MTSL_REPUTATION_LEVELS) do
			if v == rep_id then
				return k
			end
		end
		-- Not found so return "Unknown"
		return "Unknown"
	end,

	----------------------------------------------------------------------------------------
	-- Gives the level of the standing (0-8) based on the name of the level
	--
	-- @rep_name	String		The name of the replevel
	--
	-- return		number		The standing with the rep (0-8)
	-----------------------------------------------------------------------------------------
	GetReputationLevelByLevelName = function (self, rep_name)
		rep_name = string.upper(rep_name)
		if MTSL_REPUTATION_LEVELS[rep_name] ~= nil then
			return MTSL_REPUTATION_LEVELS[rep_name]
		end
		-- Not found so return 0 = "Unknown"
		return MTSL_REPUTATION_LEVELS.UNKNOWN
	end,

	----------------------------------------------------------------------------------------
	-- Check if we unlearned a profession (No need for cooking or FA, can't unlearn those)
	----------------------------------------------------------------------------------------
	CheckProfessions = function(self)
		if MTSL_CURRENT_PLAYER ~= nil and MTSL_CURRENT_PLAYER.TRADESKILLS ~= nil then
			for k, v in pairs(MTSL_CURRENT_PLAYER.TRADESKILLS) do
				-- Skip cooking and first aid, cant be unlearned
				if v.name ~= "Cooking" and v.name ~= "First Aid" and not IsSpellKnown(v.SPELLID_HIGHEST_KNOWN_RANK) then
					-- delete the saved data
					v = nil
				end
			end
		end
	end,

	----------------------------------------------------------------------------------------
	-- Converts an array to string (Only a single depth array)
	--
	-- @array		Array		The array (No multi arrays!)
	--
	-- return		String		The elements joined by a comma
	-----------------------------------------------------------------------------------------
	ConvertArrayToString = function(self, array)
		local string = ""
		for k,v in pairs(array) do
			string = string .. v .. ", "
		end
		return string
	end,

	----------------------------------------------------------------------------------------
	-- Searches for tradeskills the player hasn't learned yet and add them to list
	-----------------------------------------------------------------------------------------
	SearchMissingTradeSkills = function (self)
		-- Clear the current lists
		MTSL_MISSING_TRADESKILLS = {}
		MTSL_CURRENT_TRADESKILL.MISSING_SKILLS = {}
		MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING = 0

		-- Loop all available skills
		for i=1, self:GetTotalNumberOfSkillsCurrentTradeskill() do
			local skill = self:GetSkillCurrentTradeSkillByIndex(i)
			-- There is a skill and we dont know it yet
			if skill ~= nil and self:IsTradeSkillKnown(skill["name"][MTSL_CURRENT_LANGUAGE]) == false then
				table.insert(MTSL_CURRENT_TRADESKILL.MISSING_SKILLS, skill.id)
				MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING = MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING + 1
				table.insert(MTSL_MISSING_TRADESKILLS, skill)
			end
		end
		-- search and add for missing levels
		self:SearchMissingLevels()
		-- sort the table based on min skill needed and then name (to include levels in sorting)
		table.sort(MTSL_MISSING_TRADESKILLS, function(a, b) return a.min_skill < b.min_skill end)
		MTSL_CURRENT_TRADESKILL.AMOUNT_LEARNED = self:GetTotalNumberOfSkillsCurrentTradeskill() + MTSL_DATA.TRADESKILL_LEVELS - MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING
	end,

	----------------------------------------------------------------------------------------
	-- Searches for skill levels the player hasn't learned yet and add them to list
	-----------------------------------------------------------------------------------------
	SearchMissingLevels = function(self)
		-- Skip the known levels
		local highest_skilllevel_learned = 0
		for k,v in pairs(self:GetLevelsCurrentTradeskill()) do
			if IsSpellKnown(v.id) then
				if v.max_skill > highest_skilllevel_learned then
					highest_skilllevel_learned = v.max_skill
					MTSL_CURRENT_TRADESKILL.SPELLID_HIGHEST_KNOWN_RANK = v.id
				end
			else
				-- we only know highest spell, so skip lower spells
				if v.min_skill > MTSL_CURRENT_TRADESKILL.SKILL_LEVEL then
					local skill = self:GetLevelCurrentTradeSkillById(v.id)
					table.insert(MTSL_CURRENT_TRADESKILL.MISSING_SKILLS, skill.id)
					MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING = MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING + 1
					table.insert(MTSL_MISSING_TRADESKILLS, skill)
				end
			end
		end
	end,

	-------------------------------------------------------------------------------
	-- Refreshes the info for the current opened tradeskill frame
	-------------------------------------------------------------------------------
	UpdateCurrentTradeSkillInfo = function (self)
		local trade_skill_name, current_level, max_level = GetTradeSkillLine()
		-- Get the English name for the localised name (removed for now)
		trade_skill_name = MTSL_LOCALES_PROFESSIONS[MTSL_CURRENT_LANGUAGE][trade_skill_name]
		-- added another check against poisons
		if trade_skill_name ~= nil and trade_skill_name ~= "Poisons" then
			MTSL_CURRENT_TRADESKILL = self:GetTradeSkill(trade_skill_name)
			-- update the saved data
			MTSL_CURRENT_TRADESKILL.NAME = trade_skill_name
			MTSL_CURRENT_TRADESKILL.SKILL_LEVEL = current_level
			MTSL_CURRENT_TRADESKILL.MAXLEVEL = max_level
			self:SearchMissingTradeSkills()
			return true
		-- update failed
		else
			return false
		end
	end,

	-------------------------------------------------------------------------------
	-- Returns the saved data from the player for the wanted trade skill
	-------------------------------------------------------------------------------
	GetTradeSkill = function(self, trade_skill_name)
		-- Try and get a saved skill
		local trade_skill =  MTSL_CURRENT_PLAYER.TRADESKILLS[trade_skill_name]
		-- Skill not saved yet so create a new save
		if trade_skill == nil then
			MTSL_CURRENT_PLAYER.TRADESKILLS[trade_skill_name] = {}
			trade_skill = MTSL_CURRENT_PLAYER.TRADESKILLS[trade_skill_name]
		end

		return trade_skill
	end,

	-----------------------------------------------------------------------------------------------
	-- Checks if a certain skill is learned for the current tradeskil
	--
	-- @search_skill_name	String		The name of the skill to search
	--
	-- return				number		Flag that indicates if skill is learned (1 = yes, 0 = no)
	------------------------------------------------------------------------------------------------
	IsTradeSkillKnown = function (self, search_skill_name)
		local skillName, skillType
		-- Loop all known skills until we find it
		for i=1,GetNumTradeSkills() do
			skillName, skillType = GetTradeSkillInfo(i)
			-- Skip the headers, only check real skills
			if skillName ~= nil and skillType ~= "header" and
					search_skill_name == skillName then
				return true
			end
		end
		-- Skill not found so return false
		return false
	end,

	-----------------------------------------------------------------------------------------------
	-- Checks if a certain skill is learned for the current tradeskil
	--
	-- @tradeskills_player	Array		List of tradeskills of the player
	-- @search_skill_name	String		The name of the skill to search
	--
	-- return				number		Flag that indicates if skill is learned (1 = yes, 0 = no)
	------------------------------------------------------------------------------------------------
	IsTradeSkillKnownByPlayer = function (self, tradeskills_player, search_skill_name)
		for k, v in pairs(tradeskills_player) do
			if k == search_skill_name then
				return true
			end
		end
		-- Skill not found so return false
		return false
	end,

	-------------------------------------------------------------------------------
	-- Refreshes the info for the current opened craftskill frame
	-------------------------------------------------------------------------------
	UpdateCurrentCraftInfo = function (self)
		local trade_skill_name, current_level, max_level = GetCraftDisplaySkillLine()
		-- Get the English name for the localised name (removed for now)
		trade_skill_name = MTSL_LOCALES_PROFESSIONS[MTSL_CURRENT_LANGUAGE][trade_skill_name]
		-- Compare the opened window with current tradeskill
		-- We are updating the current tradeskill so refresh skills
		if trade_skill_name ~= nil and trade_skill_name == "Enchanting" then
			MTSL_CURRENT_TRADESKILL = self:GetTradeSkill(trade_skill_name)
			-- update the saved data
			MTSL_CURRENT_TRADESKILL.NAME = trade_skill_name
			MTSL_CURRENT_TRADESKILL.SKILL_LEVEL = current_level
			MTSL_CURRENT_TRADESKILL.MAXLEVEL = max_level
			self:SearchMissingCraftSkills()
			return true
		-- update failed
		else
			return false
		end
	end,

	----------------------------------------------------------------------------------------
	-- Searches for craftskills the player hasn't learned yet and add them to list
	-----------------------------------------------------------------------------------------
	SearchMissingCraftSkills = function (self)
		-- Reset the saved data for the current craft
		MTSL_MISSING_TRADESKILLS = {}
		MTSL_CURRENT_TRADESKILL.MISSING_SKILLS = {}
		MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING = 0
		-- Loop all available skills
		for i=1, self:GetTotalNumberOfSkillsCurrentTradeskill() do
			local skill = self:GetSkillCurrentTradeSkillByIndex(i)
			-- There is a skill and we dont know it yet
			if skill ~= nil and self:IsCraftSkillKnown(skill["name"][MTSL_CURRENT_LANGUAGE]) == 0 then
				table.insert(MTSL_CURRENT_TRADESKILL.MISSING_SKILLS, skill.id)
				MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING = MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING + 1
				table.insert(MTSL_MISSING_TRADESKILLS, skill)
			end
		end

		-- search and add for missing levels
		self:SearchMissingLevels()
		-- sort the table based on min skill needed and then name (to include levels in sorting)
		table.sort(MTSL_MISSING_TRADESKILLS, function(a, b) return a.min_skill < b.min_skill end)
		MTSL_CURRENT_TRADESKILL.AMOUNT_LEARNED = self:GetTotalNumberOfSkillsCurrentTradeskill() + MTSL_DATA.TRADESKILL_LEVELS - MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING
	end,

	-----------------------------------------------------------------------------------------------
	-- Get All the skills for one profession sorted by name or minimim skill
	--
	-- @prof_name			String		The name of the profession
	-- @sorted_by_name		Boolean		Flag indicating the sorting will be by name or by minimum skill
	--
	-- return				Array		All the skills for one profession sorted by name or minimim skill
	------------------------------------------------------------------------------------------------
	GetAllSkillsForProfession = function(self, prof_name, sorted_by_name)
		local profession_skills = {}

		if MTSL_DATA[prof_name] ~= nil then
			-- add all the skills
			for k, v in pairs(MTSL_DATA[prof_name]["skills"]) do
				table.insert(profession_skills, v)
			end
			-- add all the levels
			for k, v in pairs(MTSL_DATA[prof_name]["levels"]) do
				table.insert(profession_skills, v)
			end
			-- sort the array
			if sorted_by_name then
				table.sort(profession_skills, function(a, b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)
			else
				table.sort(profession_skills, function(a, b) return a.min_skill < b.min_skill end)
			end
		end
		return profession_skills
	end,

	-----------------------------------------------------------------------------------------------
	-- Get All the known skills for one profession sorted by name or minimim skill
	--
	-- @prof_name			String		The name of the profession
	-- @missing_skills		Array		List of skills not yet known
	-- @sorted_by_name		Boolean		Flag indicating the sorting will be by name or by minimum skill
	--
	-- return				Array		All the skills for one profession sorted by name or minimim skill
	------------------------------------------------------------------------------------------------
	GetAllKnownSkillsForProfession = function(self, prof_name, missing_skills, sorted_by_name)
		local profession_skills = {}

		if MTSL_DATA[prof_name] ~= nil then
			-- add all the skills
			for k, v in pairs(MTSL_DATA[prof_name]["skills"]) do
				-- Only add if its not a missing skill
				if not self:ListContainsNumber(missing_skills, v.id) then
					table.insert(profession_skills, v)
				end
			end
			-- add all the levels
			for k, v in pairs(MTSL_DATA[prof_name]["levels"]) do
				-- Only add if its not a missing skill
				if not self:ListContainsNumber(missing_skills, v.id) then
					table.insert(profession_skills, v)
				end
			end
			-- sort the array
			if sorted_by_name then
				table.sort(profession_skills, function(a, b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)
			else
				table.sort(profession_skills, function(a, b) return a.min_skill < b.min_skill end)
			end
		end
		return profession_skills
	end,

	-----------------------------------------------------------------------------------------------
	-- Checks if a certain skill is learned for the current craftskill
	--
	-- @search_skill_name	String		The name of the skill to search
	--
	-- return				number		Flag that indicates if skill is learned (1 = yes, 0 = no)
	------------------------------------------------------------------------------------------------
	IsCraftSkillKnown = function (self, search_skill_name)
		local skillName, skillType
		-- Loop all known skills until we find it
		for i=1,GetNumCrafts() do
			skillName, skillType = GetCraftInfo(i)
			-- Skip the headers, only check real skills
			if skillName ~= nil and skillType ~= "header" and
					search_skill_name == skillName then
				return 1
			end
		end
		-- Skill not found so return false
		return 0
	end,

	----------------------------------------------------------------------------
	-- Gets the number of current learned skils in the tradeskill window that is opened
	--
	-- return				Number		Amount of learned skills
	------------------------------------------------------------------------------------------------
	GetAmountOfTradeSkillsLearned = function(self)
		local skillName, skillType
		local amount = 0
		for i=1,GetNumTradeSkills() do
			skillName, skillType = GetTradeSkillInfo(i)
			-- Skip the headers, only count real skills
			if (skillName and skillType ~= "header") then
				amount = amount + 1
			end
		end

		return amount
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a list of all skills  for the current Tradeskill
	--
	-- return				Array		List of skills for current tradeskill
	------------------------------------------------------------------------------------------------
	GetSkillsCurrentTradeskill = function (self)
		return MTSL_DATA[MTSL_CURRENT_TRADESKILL.NAME].skills
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a list of all levels for the current Tradeskill
	--
	-- return				Array		List of levels for current tradeskill
	------------------------------------------------------------------------------------------------
	GetLevelsCurrentTradeskill = function (self)
		return MTSL_DATA[MTSL_CURRENT_TRADESKILL.NAME].levels
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a list of all recipes for the current Tradeskill
	--
	-- return				Array		List of skills for recipes tradeskill
	------------------------------------------------------------------------------------------------
	GetRecipesCurrentTradeskill = function (self)
		return MTSL_DATA[MTSL_CURRENT_TRADESKILL.NAME].recipes
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a list of all npcs (based on their ids) available to the player's faction
	--
	-- @ids					Array		The ids of NPCs to search
	--
	-- return				Array		List of found NPCs
	------------------------------------------------------------------------------------------------
	GetNpcsByIds = function(self, ids)
		local npcs = {}

        for k, id in pairs(ids)
        do
			local npc = self:GetNpcById(id)
			-- If we found one, check if the faction is valid (= neutral OR the same faction as player
			if npc ~= nil then
				if MTSL_CURRENT_PLAYER.FACTION == npc.reacts or npc.reacts == "Neutral" then
					table.insert(npcs, npc)
                end
            else
                print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not find NPC with id " .. id .. ". Please report this bug!")
			end
		end

		-- Sort the mobs by name in the table
		table.sort(npcs, function(a,b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)

		-- Return the found npcs
		return npcs
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a list of all items (based on their ids)
	--
	-- @ids					Array		The ids of items to search
	--
	-- return				Array		List of found items
	------------------------------------------------------------------------------------------------
	GetItemsCurrentTradeSkillByIds = function(self, ids)
		local items = {}

        for k, id in pairs(ids)
        do
            local item = self:GetItemCurrentTradeSkillById(id)
			-- If we found one add to list
			if item ~= nil then
				table.insert(items, item)
			else
                print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not find item with id " .. id .. " for " .. MTSL_CURRENT_TRADESKILL.NAME .. ". Please report this bug!")
            end
        end

		-- Sort the items by name in the table
		table.sort(items, function(a,b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)

		-- Return the found items
		return items
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a list of all objects (based on their ids)
	--
	-- @ids					Array		The ids of objects to search
	--
	-- return				Array		List of found items
	------------------------------------------------------------------------------------------------
	GetObjectsByIds = function(self, ids)
		local objects = {}

        for k, id in pairs(ids)
        do
			local object = self:GetObjectById(id)
			-- If we found one add to list
			if object ~= nil then
				table.insert(objects, object)
            else
                print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not find object with id " .. id .. " for " .. MTSL_CURRENT_TRADESKILL.NAME .. ". Please report this bug!")
            end
        end

		-- Sort the objects by name in the table
		table.sort(objects, function(a,b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)

		-- Return the found objects
		return objects
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a list of all drop mobs (based on their ids) for the current Tradeskill
	--
	-- @ids					Array		The ids of mobs to search
	--
	-- return				Array		List of found mobs
	------------------------------------------------------------------------------------------------
	GetMobsByIds = function(self, ids)
		local mobs = {}

        for k, id in pairs(ids)
        do
			local mob = self:GetNpcById(id)
			-- Check if we found one
			if mob ~= nil then
				-- only add mob if player can attack it
				if mob.reacts ~= MTSL_CURRENT_PLAYER.FACTION then
					table.insert(mobs, mob)
				end
            else
                print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not find mob with id " .. id .. " for " .. MTSL_CURRENT_TRADESKILL.NAME .. ". Please report this bug!")
            end
        end

		-- Sort the mobs by name in the table
		table.sort(mobs, function(a,b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)

		-- Return the found npcs
		return mobs
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets an NPC (based on it's id) for the current Tradeskill
	--
	-- @id				Number		The id of the NPC to search
	--
	-- return			Object		Found NPC (nil if not found)
	------------------------------------------------------------------------------------------------
	GetNpcById = function(self, id)
		return self:GetItemFromSortedListById(MTSL_DATA["npcs"], id)
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets an object (based on it's id)
	--
	-- @id				Number		The id of the item to search
	--
	-- return			Object		Found item (nil if not found)
	------------------------------------------------------------------------------------------------
	GetObjectById = function(self, id)
		return self:GetItemFromSortedListById(MTSL_DATA["objects"], id)
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a quest available to the player's faction (based on it's ids)
	--
	-- @id				Number		The ids of the quests to search
	--
	-- return			Object		Found quest (nil if not found)
	------------------------------------------------------------------------------------------------
	GetQuestByIds = function(self, ids)
		local i = 1

		while ids[i] ~= nil do
			quest = self:GetItemFromSortedListById(MTSL_DATA["quests"], ids[i])
			-- Check if q started from NPC
			if quest ~= nil then
				if quest.npcs ~= nil then
					npcs = self:GetNpcsByIds(quest.npcs)
					if npcs == nil  then
						print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not find NPCs for Quest with id " .. ids[i] .. ". Report this bug!")
					else
						-- only 1 NPC possible
						local npc = npcs[1]
						-- check if we are able to interact with npc
						if npc ~= nil then
							if npc.reacts == "Neutral" or npc.reacts == MTSL_CURRENT_PLAYER.FACTION then
								return quest
							end
						end
					end
					-- Started from item/object so available to all
				else
					return quest
				end
			else
                print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL - Could not find quest with id " .. ids[i] .. ". Report this bug!")
			end

			i = i + 1
		end

		return nil
	end,

	----------------------------------------------------------------------------------------------
	-- Gets an item (based on it's id) for the current Tradeskill
	--
	-- @id				Number		The id of the recipe to search
	--
	-- return			Object		Found item (nil if not found)
	------------------------------------------------------------------------------------------------
	GetItemCurrentTradeSkillById = function(self, id)
		return self:GetItemFromSortedListById(MTSL_DATA[MTSL_CURRENT_TRADESKILL.NAME].items, id)
	end,

	----------------------------------------------------------------------------------------------
	-- Gets an item (based on it's id) for a Tradeskill
	--
	-- @id					Number		The id of the recipe to search
	-- @trade_skill_name	String		The name of the tradeskill
	--
	-- return				Object		Found item (nil if not found)
	------------------------------------------------------------------------------------------------
	GetItemById = function(self, id, trade_skill_name)
		return self:GetItemFromSortedListById(MTSL_DATA[trade_skill_name].items, id)
	end,


	-----------------------------------------------------------------------------------------------
	-- Gets a skill (based on it's index in list of all skills) for the current Tradeskill
	--
	-- @index			Number		The index of the skill to search
	--
	-- return			Object		Found skill (nil if not  in list)
	------------------------------------------------------------------------------------------------
	GetSkillCurrentTradeSkillByIndex = function(self, index)
		local all_skills = self:GetSkillsCurrentTradeskill()
		return all_skills[index]
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a missing skill (based on it's index in list of all skills) for the current Tradeskill
	--
	-- @index			Number		The index of the skill to search
	--
	-- return			Object		Found skill (nil if not  in list)
	------------------------------------------------------------------------------------------------
	GetMissingSkillCurrentTradeSkillByIndex = function(self, index)
		return MTSL_MISSING_TRADESKILLS[index]
	end,

	-----------------------------------------------------------------------------------------------
	-- Gets a skill (based on it's id) for the current Tradeskill
	--
	-- @id				Number		The id of the skill to search
	--
	-- return			Object		Found skill (nil if not  in list)
	------------------------------------------------------------------------------------------------
	GetSkillCurrentTradeSkillById = function(self, skill_id)
		local total_number_skills = self:GetTotalNumberOfSkillsCurrentTradeskill()
		local all_skills = self:GetSkillsCurrentTradeskill()
		for i=1,total_number_skills do
			if all_skills ~= nil and all_skills[i].id == skill_id then
				return all_skills[i]
			end
		end
	end,

	------------------------------------------------------------------------------------------------
	-- Gets a level (based on it's id) for the current Tradeskill
	--
	-- @id				Number		The id of the skill to search
	--
	-- return			Object		Found skill (nil if not  in list)
	------------------------------------------------------------------------------------------------
	GetLevelCurrentTradeSkillById = function(self, level_id)
		for k, v in pairs(self:GetLevelsCurrentTradeskill()) do
			if v ~= nil and v.id == level_id then
				return v
			end
		end
	end,

	------------------------------------------------------------------------------------------------
	-- Searches an array to see if it contains a number
	--
	-- @list			Array		The list to search
	-- @number			Number		The number to search
	--
	-- return			boolean		Flag indicating if number is foundFound skill (nil if not  in list)
	------------------------------------------------------------------------------------------------
	ListContainsNumber = function(self, list, number)
		if list == nil then
			return false
		end
		local i = 1
		while list[i] ~= nil and list[i] ~= number do
			i = i + 1
		end
		return list[i] == nil
	end,

	------------------------------------------------------------------------------------------------
	-- Gets the status for a player for a skill of a Tradeskill
	--
	-- @player				Object		The player for who to check
	-- @trade_skill_name	String		The name of the trade skill
	-- @skill_id			Number		The id of the skill to search
	--
	-- return				Number		Status of the skill
	------------------------------------------------------------------------------------------------
	IsSkillKnownForPlayer = function(self, player, trade_skill_name, skill_id)
		local trade_skill = player.TRADESKILLS[trade_skill_name]
		-- returns 0 if tade_skill not trained, 1 if trained but skill not learned and current skill to low, 2 if skill is learnable, 4 if skill learned
		local known_status
		if trade_skill == nil or trade_skill == 0 then
			known_status = 0
		else
			local skill_known = self:ListContainsNumber(trade_skill.MISSING_SKILLS, skill_id)
			if skill_known  then
				known_status = 3
			else
				-- try to find the skill
				local skill = self:GetItemFromUnsortedListById(MTSL_DATA[trade_skill_name]["skills"], skill_id)
				-- its a level
				if skill == nil then
					skill = self:GetItemFromUnsortedListById(MTSL_DATA[trade_skill_name]["levels"], skill_id)
				end
				if trade_skill.SKILL_LEVEL < skill.min_skill then
					known_status = 1
				else
					known_status = 2
				end
			end
		end
		return known_status
	end,

	------------------------------------------------------------------------------------------------
	-- Converts old savedvariables using PRIMARY and SECONDARY to new layout
	------------------------------------------------------------------------------------------------
	ConvertSavedData = function(self)
		if MTSL_PLAYERS ~= nil and MTSL_PLAYERS ~= {} then
			-- loop realms
			for a, b in pairs(MTSL_PLAYERS) do
				-- loop players
				for c, d in pairs(b) do
					-- move the primary to an index
					if d.TRADESKILLS.PRIMARY ~= nil and d.TRADESKILLS.PRIMARY ~= 0 and d.TRADESKILLS.PRIMARY.NAME ~= nil then
						-- dont move/copy if poisons
						if d.TRADESKILLS.PRIMARY.NAME ~= "Poisons" then
							d.TRADESKILLS[d.TRADESKILLS.PRIMARY.NAME] = self:CopyObject(d.TRADESKILLS.PRIMARY)
						end
					end
					d.TRADESKILLS.PRIMARY = nil
					-- move the secondary to an index
					if d.TRADESKILLS.SECONDARY ~= nil and TRADESKILLS.SECONDARY ~= 0 and d.TRADESKILLS.SECONDARY.NAME ~= nil then
						-- dont move/copy if poisons
						if d.TRADESKILLS.SECONDARY.NAME ~= "Poisons" then
							d.TRADESKILLS[d.TRADESKILLS.SECONDARY.NAME] = self:CopyObject(d.TRADESKILLS.SECONDARY)
						end
					end
					d.TRADESKILLS.SECONDARY = nil
					-- change the uppercasing and name of first aid and cooking
					if d.TRADESKILLS.COOKING ~= nil and TRADESKILLS.COOKING ~= 0 then
						d.TRADESKILLS["Cooking"] = self:CopyObject(d.TRADESKILLS.COOKING)
					end
					d.TRADESKILLS.COOKING = nil
					if d.TRADESKILLS.FIRST_AID ~= nil and TRADESKILLS.FIRST_AID ~= 0 then
						d.TRADESKILLS["First Aid"] = self:CopyObject(d.TRADESKILLS.FIRST_AID)
					end
					d.TRADESKILLS.FIRST_AID = nil
				end
			end
		end
	end,

	------------------------------------------------------------------------------------------------
	-- Reset the content of the savedvariable to have a "clean" install
	------------------------------------------------------------------------------------------------
	ResetSavedData = function(self)
		MTSL_PLAYERS = {}
		MTSL_SCALE_UI = 0.7
		print(MTSLUI_FONTS.COLORS.TEXT.SUCCESS .. "MTSL: Saved data reset!")
	end,

	------------------------------------------------------------------------------------------------
	-- Removes a character from the saved data
	------------------------------------------------------------------------------------------------
	RemoveCharacter = function(self, name, realm)
		if realm ~= nil and name ~= nil then
			if MTSL_PLAYERS[realm] == nil then
				print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Realm " .. realm .. " does not exist in saved data! Names are case sensitive")
			elseif MTSL_PLAYERS[realm][name] == nil then
				print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Realm " .. realm .. " does not have saved data for " .. name .. "! Names are case sensitive")
			else
				MTSL_PLAYERS[realm][name] = nil
				print(MTSLUI_FONTS.COLORS.TEXT.SUCCESS .. "MTSL: Removed " .. name .. " on realm " .. realm .. " from the saved data! Logout to complete.")
			end
		else
			print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Realm and character name are needed to delete a char")
		end
	end,

	------------------------------------------------------------------------------------------------
	-- Returns the number of characters
	--
	-- returns 	Number		The number of chars (on that realm)
	------------------------------------------------------------------------------------------------
	CountPlayers = function(self)
		local amount = 0
		for k, realm in pairs(MTSL_PLAYERS) do
			amount = amount + self:CountPlayersOnRealm(k)
		end
		print("Total amount of players: " .. amount)
		return amount
	end,

	------------------------------------------------------------------------------------------------
	-- Returns the number of characters
	--
	-- @realm	String 		The name of the realm
	--
	-- returns 	Number		The number of chars on that realm
	------------------------------------------------------------------------------------------------
	CountPlayersOnRealm = function(self, realm)
		local amount = 0
		if MTSL_PLAYERS[realm] ~= nil then
			for k, player in pairs(MTSL_PLAYERS[realm] ) do
				amount = amount + 1
			end
		end

		return amount
	end,

	------------------------------------------------------------------------------------------------
	-- Returns the name (localised) of a zone by id
	--
	-- @zone_id		Number		The id of the zone
	--
	-- returns 		String		The localised name of the zone
	------------------------------------------------------------------------------------------------
	GetZoneNameById = function(self, zone_id)
		local zone = self:GetItemFromUnsortedListById(MTSL_DATA["zones"], zone_id)
		if zone == nil then
			print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "No zone found for id " .. zone_id .. "! Please report this bug!")
			return ""
		else
			return zone["name"][MTSL_CURRENT_LANGUAGE]
		end
	end,

	------------------------------------------------------------------------------------------------
	-- Returns the name (localised) of a faction by id
	--
	-- @faction_id		Number		The id of the faction
	--
	-- returns 			String		The localised name of the faction
	------------------------------------------------------------------------------------------------
	GetFactionNameById = function(self, faction_id)
		local faction = self:GetItemFromUnsortedListById(MTSL_DATA["factions"], faction_id)
		if faction == nil then
			print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "No faction found for id " .. faction_id .. "! Please report this bug!")
			return ""
		else
			return faction["name"][MTSL_CURRENT_LANGUAGE]
		end
	end,

	------------------------------------------------------------------------------------------------
	-- Returns the name (localised) of a reputation level by id
	--
	-- @level_id		Number		The id of the repuation level
	--
	-- returns 			String		The localised name of the reputation level
	------------------------------------------------------------------------------------------------
	GetReputationLevelById = function(self, faction_id)
		-- Get the English name corresponding the level
		local rep_level = self:GetReputationLevelNameById(level_id)
		-- Localise  the name
		return MTSL_LOCALES_REP_LEVELS[MTSL_CURRENT_LANGUAGE][rep_level]
	end,

	------------------------------------------------------------------------------------------------
	-- Returns a list of Zones ordered by name
	--
	-- returns 		Array		The zones
	------------------------------------------------------------------------------------------------
	GetZones = function(self)
		table.sort(MTSL_DATA["zones"], function (a, b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)
		return MTSL_DATA["zones"]
	end,

	-- Gets the contintents sorted by name
	GetContintents = function(self, continent_name)
		table.sort(MTSL_DATA["continents"], function (a, b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)
		return MTSL_DATA["continents"]
	end,

	-- Get a continten by name
	GetZone = function(self, zone_name)
		for k, v in pairs(MTSL_DATA["zones"]) do
			if v["name"][MTSL_CURRENT_LANGUAGE] == zone_name then
				return v
			end
		end
		return nil
	end,

	-- Get a continten by name
	GetContintent = function(self, continent_name)
		for k, v in pairs(MTSL_DATA["continents"]) do
			if v["name"][MTSL_CURRENT_LANGUAGE] == continent_name then
				return v
			end
		end
		return nil
	end,

	-- Get a continten by name
	GetContintentById = function(self, continent_id)
		for k, v in pairs(MTSL_DATA["continents"]) do
			if v["id"] == continent_id then
				return v
			end
		end
		return nil
	end,

	------------------------------------------------------------------------------------------------
	-- Returns a list of Zones for a contintent
	--
	-- returns 		Array		The zones
	------------------------------------------------------------------------------------------------
	GetZonesInContinent = function(self, continent_name)
		local zones_contintent = {}
		local cont_id = self:GetContintent(continent_name)["id"]

		if cont_id ~= nil then
			for k, v in pairs(MTSL_DATA["zones"]) do
				if v["cont_id"] == cont_id then
					table.insert(zones_contintent, v)
				end
			end
			table.sort(zones_contintent, function (a, b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)
		end
		return zones_contintent
	end,

	------------------------------------------------------------------------------------------------
	-- Returns a skills obtainable in a certain zone for a certain profession
	--
	-- zone				String		The name of the zone (ANY for all zones)
	-- prof_name		String		Name of the profession
	-- order_by_name	Boolean		Flag indicating if sorting by name or min_skill
	--
	-- returns	 		Array		The skills
	------------------------------------------------------------------------------------------------
	GetSkillForZone = function(self, zone, prof_sname, order_by_name)
		if zone == "ANY" then
			return {}
		else
			local skills = {}
			for k,v in pairs (MTSL_DATA[prof_name]["skills"]) do
				if self:IsLearnableInZone(v, zone) then
					table.insert(skills, v)
				end
			end
			if order_by_name then
				table.sort(skills, function (a, b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)
			else
				table.sort(skills, function (a, b) return a.min_skill < b.min_skill end)
			end
			return skills
		end
	end
}