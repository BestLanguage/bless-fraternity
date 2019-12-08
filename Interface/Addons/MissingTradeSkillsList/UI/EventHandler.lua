------------------------------------------------------------------
-- Name: EventHandler								  			--
-- Description: handles all the UI events needed for the addon 	--
------------------------------------------------------------------

MTSLUI_EVENT_HANDLER = {
	-- flags keeping track if window is open or not
	ui_trade_open = 0,
	ui_craft_open = 0,
    addon_loaded = 0,

	---------------------------------------------------------------------------------------
	-- Event started when our addon is fully loaded
	---------------------------------------------------------------------------------------
	PLAYER_LOGIN = function (self)
		if MTSL_TOOLS:CheckIfDataIsValid() then
			-- convert old data to new save format
			MTSL_TOOLS:ConvertSavedData()

			if MTSLUI_TOOLS:SetAddonLocale() then
				-- print loaded message
				print(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSL_ADDON.NAME .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. " (by " .. MTSL_ADDON.AUTHOR .. ")" .. MTSLUI_FONTS.COLORS.TEXT.TITLE .. " v" .. MTSL_ADDON.VERSION .. " loaded!")
				-- load the data for the player
				MTSL_TOOLS:LoadPlayer()
				self.addon_loaded = 1
			else
				print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Your locale " .. GetLocale() .. " is not supported!")
				self.addon_loaded = 0
			end
		else
			self.addon_loaded = 0
		end
	end,
	
	---------------------------------------------------------------------------------------
	-- Event started when a crafting window is closed
	---------------------------------------------------------------------------------------
	CRAFT_CLOSE = function (self)
		self.ui_craft_open = 0
		-- if we have a tradeskill window open, reanchor togglebutton and refresh frame
		if self.ui_trade_open > 0 then
			self:TRADE_SKILL_SHOW()
			self:TRADE_SKILL_UPDATE()
		-- no other window was open so close the addon
		else
			MTSLUI_TOGGLE_BUTTON:Hide()
			MTSLUI_MISSING_TRADESKILLS_FRAME:Hide()
		end
	end,
	
	---------------------------------------------------------------------------------------
	-- Event started when a crafting window is opened
	---------------------------------------------------------------------------------------
	CRAFT_SHOW = function (self)
        -- Check if we effectively opened a CraftFrame
		if CraftFrame then
			local localised_name = GetCraftDisplaySkillLine()
			localised_name = MTSL_LOCALES_PROFESSIONS[MTSL_CURRENT_LANGUAGE][localised_name]
			-- There are other craftframes like (Beast Training) so we only want enchanting
			if localised_name ~= nil and localised_name == "Enchanting" then
				self.ui_craft_open = 1
				MTSLUI_TOGGLE_BUTTON:SwapToCraftMode()
				MTSLUI_TOGGLE_BUTTON:Show()
				MTSLUI_MISSING_TRADESKILLS_FRAME:NoSkillSelected()
			end
		end
	end,
	
	---------------------------------------------------------------------------------------
	-- Event started when a crafting window is updated
	---------------------------------------------------------------------------------------
	CRAFT_UPDATE = function (self)
		if MTSL_TOOLS:UpdateCurrentCraftInfo() then
			MTSLUI_MISSING_TRADESKILLS_FRAME:RefreshUI()
		end
	end,
		
	---------------------------------------------------------------------------------------
	-- Event started when a skill point is gained or unlearned a profession
	---------------------------------------------------------------------------------------
	SKILL_LINES_CHANGED = function (self)
		-- Check if we unlearned a profession (only possbile if SkillFrame is shown and active
		if SkillFrame and SkillFrame:IsVisible() then
			MTSL_TOOLS:CheckProfessions()
		end
	end,
	
	---------------------------------------------------------------------------------------
	-- Event started when a trade skill windows is closed
	---------------------------------------------------------------------------------------
	TRADE_SKILL_CLOSE = function (self)
		self.ui_trade_open = 0
		-- if we have a tradeskill window open, reanchor togglebutton and refresh frame
		if self.ui_craft_open > 0 then
			self:CRAFT_SHOW()
			self:CRAFT_UPDATE()
		-- no other window was open so close the addon
		else
			MTSLUI_TOGGLE_BUTTON:Hide()
			MTSLUI_MISSING_TRADESKILLS_FRAME:Hide()
		end
	end,
	
	---------------------------------------------------------------------------------------
	-- Event started when a trade skill windows is opened
	---------------------------------------------------------------------------------------
	TRADE_SKILL_SHOW = function (self)
		-- check if we are allowed to swap (this skips poisons)
		if TradeSkillFrame then
			local localised_name = GetTradeSkillLine()
			localised_name = MTSL_LOCALES_PROFESSIONS[MTSL_CURRENT_LANGUAGE][localised_name]
			if localised_name ~= nil and localised_name ~= "Poisons" then
				self.ui_trade_open = 1
        		MTSLUI_TOGGLE_BUTTON:SwapToTradeSkillMode()
				MTSLUI_TOGGLE_BUTTON:Show()
				MTSLUI_MISSING_TRADESKILLS_FRAME:NoSkillSelected()
			end
		end
	end,

	---------------------------------------------------------------------------------------
	-- Event started when a trade skill windows is updated
	---------------------------------------------------------------------------------------
	TRADE_SKILL_UPDATE = function (self)
		if MTSL_TOOLS:UpdateCurrentTradeSkillInfo() then
		    -- Only refresh the UI if we succesfully updated the skillinfo (this ignores the update with any unsupported profession)
            MTSLUI_MISSING_TRADESKILLS_FRAME:RefreshUI()
        end
	end,
	
	---------------------------------------------------------------------------------------
	-- Event started when a skill is learned from trainer
	---------------------------------------------------------------------------------------
	TRAINER_UPDATE = function (self)
		-- only possible react if we have a craft or tradeskill open
		if self.ui_craft_open > 0 or self.ui_trade_open > 0 then
			-- Check if we have a trainer window open
			if ClassTrainerFrame and ClassTrainerFrame:IsVisible() and ClassTrainerFrame.selectedService ~= nil then
				-- get the name of the profession for the current opened trainer
				local opened_trainer = GetTrainerServiceSkillLine(ClassTrainerFrame.selectedService)
				local localised_profession_name = MTSL_LOCALES_PROFESSIONS[MTSL_CURRENT_LANGUAGE][opened_trainer]
				-- check if its a profession we want to update (ignore classtrainers)
				if localised_profession_name ~= nil then
					-- only update if current profession is the opened MTSL one
					if self.ui_craft_open > 0 and MTSL_CURRENT_TRADESKILL.NAME == localised_profession_name and localised_profession_name == "Enchanting" then
						self:CRAFT_UPDATE()
					elseif self.ui_trade_open > 0 and MTSL_CURRENT_TRADESKILL.NAME == localised_profession_name and localised_profession_name ~= "Enchanting" then
						self:TRADE_SKILL_UPDATE()
					end
				end
			end
		end
	end,

	---------------------------------------------------------------------------------------
	-- Handles a slash command for this addon
	--
	-- @msg:			string		The argument for the slash command
	---------------------------------------------------------------------------------------
    SLASH_COMMAND = function (self, msg)
		msg, arg1, arg2 = strsplit(" ", msg, 3)

		if msg == "acc" or msg == "account" then
			MTSLACCUI_ACCOUNT_FRAME:Toggle()
		elseif msg == "db" or msg == "database" then
			MTSLDBUI_DATABASE_FRAME:Toggle()
		elseif msg == "about" then
            MTSLUI_TOOLS:PrintAboutMessage()
		elseif msg == "summary" then
			MTSLUI_TOOLS:PrintSummary()
		elseif msg == "scale" then
			if unexpected_condition then
				MTSLUI_TOOLS:SetScale(nil)
			end
			MTSLUI_TOOLS:SetScale(tonumber(arg1))
		elseif msg == "remove" then
			MTSL_TOOLS:RemoveCharacter(arg1, arg2)
		elseif msg == "reset" then
			MTSL_TOOLS:ResetSavedData()
		-- Not a known paramter or "help"
		else
            MTSLUI_TOOLS:PrintHelpMessage()
		end
    end,

	---------------------------------------------------------------------------------------
	-- Initialise the handler and hook all events
	---------------------------------------------------------------------------------------
	Initialise = function (self)
		-- Create an "empty" frame to hook onto
		local event_frame = CreateFrame("FRAME")
		-- Set function how to react on event
		event_frame:SetScript("OnEvent", function(eventframe, event, arg1)
            -- only execute the event if the addon is loaded OR the event = player_login
            if self.addon_loaded == 1 or event == "PLAYER_LOGIN" then
                self[event](self)
            end
		end)
		-- Event thrown when player has logged in
		event_frame:RegisterEvent("PLAYER_LOGIN")
		-- Events for crafts (= Enchanting)
		event_frame:RegisterEvent("CRAFT_CLOSE")
		event_frame:RegisterEvent("CRAFT_SHOW")
		event_frame:RegisterEvent("CRAFT_UPDATE")
		-- Gained a skill point
		event_frame:RegisterEvent("SKILL_LINES_CHANGED")
		-- Events for trade skills (= all but enchanting)
		event_frame:RegisterEvent("TRADE_SKILL_CLOSE")
		event_frame:RegisterEvent("TRADE_SKILL_SHOW")
		event_frame:RegisterEvent("TRADE_SKILL_UPDATE")
		-- Learned Skill from trainer
		event_frame:RegisterEvent("TRAINER_UPDATE")
	end,
}