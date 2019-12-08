------------------------------------------------------------------
-- Name: ToggleButton											--
-- Description: Contains all functionality for the togglebutton --
------------------------------------------------------------------
MTSLUI_TOGGLE_BUTTON = {
	-- the frame of this toggle button
	ui_frame = nil,
	FRAME_WITDH = 60,
	FRAME_HEIGHT = 20,
	ui_mode,

	---------------------------------------------------------------------------------------
	-- Hides the togglebutton
	----------------------------------------------------------------------------------------
	Hide = function (self)
		self.ui_frame:Hide()
	end,
	
	---------------------------------------------------------------------------------------
	-- Shows the togglebutton
	----------------------------------------------------------------------------------------
	Show = function (self)
		self.ui_frame:Show()
	end,
	
	---------------------------------------------------------------------------------------
	-- Initialises the togglebutton
	----------------------------------------------------------------------------------------
	Initialise = function (self)
		self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Button", "MTSLUI_ToggleButton", nil, "UIPanelButtonTemplate", self.FRAME_WITDH, self.FRAME_HEIGHT)
		self.ui_frame:SetText("MTSL")
		self.ui_frame:SetScript("OnClick", function ()
			MTSLUI_MISSING_TRADESKILLS_FRAME:Toggle()
		end)
		-- Hide by default after creating
		self:Hide()
	end,

	------------------------------
	-- Swaps to Craft Mode
	------------------------------
	SwapToCraftMode = function(self)
		-- Can only swap if craftframe is init
		if CraftFrame ~= nil then
			self.ui_frame:SetParent(CraftFrame)
			self.ui_frame:SetPoint("BOTTOMRIGHT", CraftFrame, "TOPRIGHT", -33, -13)
			self.ui_mode = "CRAFT"
			-- clear any current selection of the tradeskill window
			MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:Reset()
		end
	end,
	
	-------
	-- Swaps to Craft Mode
	-------
	SwapToTradeSkillMode = function(self)
		-- Can only swap if craftframe is init
		if TradeSkillFrame ~= nil then
			self.ui_frame:SetParent(TradeSkillFrame)
			self.ui_frame:SetPoint("BOTTOMRIGHT", TradeSkillFrame, "TOPRIGHT", -33, -13)
			self.ui_mode = "TRADE"
			-- clear any current selection of the craftskill window
			MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:Reset()
		end
	end,

	GetUIMode = function (self)
		return self.ui_mode
	end,
}
