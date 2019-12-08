-------------------------------------------------------------
-- Name: MTSLUI_Tools									   --
-- Description: contains all shared functions regarding UI --
-------------------------------------------------------------
MTSLUI_TOOLS = {
	-- flag to warn ppl to install tomtom before it can add waypoints
	tomtom_warned = false,

	---------------------------------------------------------------------------------------
	-- Create a generic MTSLUI_FRAME
	--
	-- @type:			string		Type of the frame ("Frame", "Button", "Slider")
	-- @name:			string		The name of the frame
	-- @parent:			ojbect		The parentframe (can be nil)
	-- @template:		string		The name of the template to follow (can be nil)
	-- @width:			number		The width of the frame
	-- @height:			number		The height of the frame
	-- @has_backdrop	boolean		Frame has backgroound or not (can be nil)
	--
	-- returns			Frame		Returns the created frame
	----------------------------------------------------------------------------------------
	CreateBaseFrame = function (self, type, name, parent, template, width, height, has_backdrop)
		local generic_frame = CreateFrame(type, name, parent, template)
		generic_frame:SetWidth(width)
		generic_frame:SetHeight(height)
		generic_frame:SetParent(parent)
		-- Add a background to the frame if we want it
		if has_backdrop ~= nil and has_backdrop == true then
			generic_frame:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 }
			})
			--  Black background
			generic_frame:SetBackdropColor(0,0,0,1)
		end
		-- make sure mouse is captured on our window (NO clicking through)
		generic_frame:EnableMouse(1)
		-- Disable zooming in/out
		generic_frame:EnableMouseWheel(true)
		generic_frame:Show()
		-- return the frame
		return generic_frame
	end,

	----------------------------------------------------------------------------------------
	-- Creates a label for the given frame
	--
	-- @owner		Frame		The frame for which to create the label
	-- @text		String		The text to show on the label
	-- @left		Number		The left position where the label starts
	-- @top			Number		The top position where the label starts
	--
	-- returns		Object		The created label
	----------------------------------------------------------------------------------------
	CreateLabel = function (self, owner, text, left, top, font_size, position)
		local new_label = owner:CreateFontString()
		new_label:SetFont(MTSLUI_FONTS.FONTS[font_size]:GetFont())

		new_label:SetPoint(position, left, top)
		if text ~= nil or text ~= "" then
			new_label:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. text)
		end
		return new_label
	end,

	-----------------------------------------------------------------------------------------
	-- Create a generic ScrollFrame
	--
	-- @parent_class		ojbect		The parentclass
	-- @parent_frame		ojbect		The parentframe
	-- @width				number		The width of the frame
	-- @height				number		The height of the frame
	-- @has_backdrop		boolean		Frame has backgroound or not (can be nil)
	-- @slider_steps		number		The amount of steps the slider has
	-- @height_slider_step	number		The height of 1 step in the slider
	--
	-- returns				Frame		Returns the created frame
	----------------------------------------------------------------------------------------
	CreateScrollFrame = function (self, parent_class, parent_frame, width, height, has_backdrop, height_slider_step)
		local scroll_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, width, height, has_backdrop)
		-- add the vertical slider on the right to the frame
		scroll_frame.slider = MTSL_TOOLS:CopyObject(MTSLUI_VERTICAL_SLIDER)
		scroll_frame.slider:Initialise(parent_class, scroll_frame, height, height_slider_step)
		-- Make the frame scrollable
		scroll_frame:EnableMouseWheel(true)
		-- add mousewheel event to scrollframe
		scroll_frame:SetScript("OnMouseWheel", function(event_frame, delta)
			-- Only scroll if delta is + or -
			if delta ~= nil then
				-- scroll up on positive delta
				if delta > 0 then
					event_frame.slider:ScrollUp()
				else
					event_frame.slider:ScrollDown()
				end
			end
		end)

		-- return the frame
		return scroll_frame
	end,

	----------------------------------------------------------------------------------------
	-- Prints info about addon to chat
	----------------------------------------------------------------------------------------
	PrintAboutMessage = function (self)
		print(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSL_ADDON.NAME)
		print(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_FONTS.TAB .. "Author: " .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSL_ADDON.AUTHOR)
		print(MTSLUI_FONTS.COLORS.TEXT.TITLE .. MTSLUI_FONTS.TAB .. "Version: " .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. MTSL_ADDON.VERSION)
	end,

	----------------------------------------------------------------------------------------
	-- Prints help about addon to chat
	----------------------------------------------------------------------------------------
	PrintHelpMessage = function (self)
		self:PrintAboutMessage()
		print("/mstl about" .. MTSLUI_FONTS.TAB .. "Print information about this addon")
		print("/mstl help" .. MTSLUI_FONTS.TAB .. "Print how to use this addon")
        print("/mstl acc " .. MTSLUI_FONTS.TAB  .. "Toggles the account wide frame - COMING SOON")
        print("/mstl account")
		print("/mstl db" .. MTSLUI_FONTS.TAB .. "Shows the database explorer window")
        print("/mstl database")
		print("/mtsl remove <name char> <name realm>"  .. MTSLUI_FONTS.TAB .. "Removes the saved data of a certain char on a realm")
		print("/mtsl reset"  .. MTSLUI_FONTS.TAB .. "Reset the saveddata of the addon ")
		print("/mtsl scale <number>"  .. MTSLUI_FONTS.TAB .. "Scale the Database Explorer & Account explorer (Number must be > 0.5 and < 1.25)")
	end,

	------------------------------------------------------------------------------------------------
	-- Sets the locale used ingame
	--
	-- returns				Boolean		Flag indicating if our language is supported
	------------------------------------------------------------------------------------------------
	SetAddonLocale = function(self)
		local locale = GetLocale()
		if MTSL_LOCALES[locale] == nil then
			print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL does not support your locale " .. GetLocale() .. "!")
			return false
		end
		MTSL_CURRENT_LANGUAGE = MTSL_LOCALES[locale]
		return true
	end,

	------------------------------------------------------------------------------------------------
	-- Gets the English name for a trade skill
	--
	-- @trade_skill_name	String		The name of the trade skill in current locale
	--
	-- return				String		The English name of the trade skill
	------------------------------------------------------------------------------------------------
	GetLocaleTradeSkillName = function(self, trade_skill_name)
		return MTSL_LOCALES_PROFESSIONS[MTSL_CURRENT_LANGUAGE][trade_skill_name]
	end,

	------------------------------------------------------------------------------------------------
	-- Gets the English name for a reputation level
	--
	-- @reputation_level	String		The name of the reputation level in current locale
	--
	-- return				String		The English name of the reputation level
	------------------------------------------------------------------------------------------------
	GetLocaleReputationLevel = function(self, reputation_level)
		return MTSL_LOCALES_REP_LEVELS[MTSL_CURRENT_LANGUAGE][reputation_level]
	end,

	------------------------------------------------------------------------------------------------
	-- Scales the UI of the addon
	--
	-- @scale			Number			The number for UI scale (must be > 0.5 and < 1.25)
	------------------------------------------------------------------------------------------------
	SetScale = function(self, scale)
		if scale == nil or scale < 0.5 or scale > 1.25 then
			print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: scale must be a number between 0.5 and 1.25")
		else
			-- save the scale for next session
			MTSL_SCALE_UI = scale
			-- rescale the main UI components/frames
			-- NO need to rescale MTSLUI_MISSING_TRADESKILLS_FRAME, it inherits scale from MTSLUI_TOGGLE_BUTTON
			MTSLDBUI_DATABASE_FRAME.ui_frame:SetScale(scale)
			MTSLACCUI_DATABASE_FRAME.ui_frame:SetScale(scale)
		end
	end,

	------------------------------------------------------------------------------------------------
	-- Gets he scale of the UI of the addon
	--
	-- return			Number			The number for UI scale (will be > 0.5 and < 1.25)
	------------------------------------------------------------------------------------------------
	GetScale = function(self)
		-- fresh addon started, so save the players scale
		if MTSL_SCALE_UI == nil then
			-- save the default scale
			MTSL_SCALE_UI = 0.7
		end
		return MTSL_SCALE_UI
	end,

	------------------------------------------------------------------------------------------------
	-- Creates a TomTom waypoint if possible
	--
	-- @label_text			String			The string containing the zonename, coords & descrption
	-- @item_name			String			The name of the item
	------------------------------------------------------------------------------------------------
	CreateWayPoint = function(self, label_text, item_name)
		-- parse the text: build up as <name npc/oject> - <name zone> (coord x, coord y)
		local name_npc, label_text = strsplit("-", label_text, 2)
		if label_text ~= nil and label_text ~= "" then
			local zone, label_text = strsplit("(", label_text, 2)
			if label_text ~= nil and label_text ~= "" then
				local x_coord, label_text = strsplit(",", label_text, 2)
				if label_text ~= nil and label_text ~= "" then
					local y_coord, label_text = strsplit(")", label_text, 2)
					if y_coord ~= nil and y_coord ~= "" then
						-- only add waypoint is tom tom is installed
						if IsAddOnLoaded("TomTom") and SlashCmdList["TOMTOM_WAY"] ~= nil then
							SlashCmdList["TOMTOM_WAY"](zone .. x_coord .. y_coord .. " " .. name_npc .. " (" .. item_name .. ")")
						elseif not self.tomtom_warned then
							print(MTSLUI_FONTS.COLORS.TEXT.WARNING .. "MTSL: You need to install TomTom to add waypoints!")
							self.tomtom_warned = true
						end
					end
				end
			end
		end
	end,
}