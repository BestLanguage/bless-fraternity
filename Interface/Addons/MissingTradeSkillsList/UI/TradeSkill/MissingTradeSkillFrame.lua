-----------------------------------------------------------------
-- Name: MissingTradeSkillFrame			                           --
-- Description: The main frame shown next to TradeSkill window --
-----------------------------------------------------------------
MTSLUI_MISSING_TRADESKILLS_FRAME = {
    ui_frame = nil,
    -- Addon frame
    FRAME_WIDTH = 865,
    FRAME_HEIGHT = 447,
    prev_amount_missing = "",
    prev_tradeskill_name = "",

    ---------------------------------------------------------------------------------------
    -- Hides the frame
    ----------------------------------------------------------------------------------------
    Hide = function (self)
        self.ui_frame:Hide()
        -- deselect any button from the list
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:DeselectCurrentSkillButton()
        prev_amount_missing = ""
        prev_tradeskill_name = ""
    end,

    ---------------------------------------------------------------------------------------
    -- Shows the frame
    ----------------------------------------------------------------------------------------
    Show = function (self)
        self.ui_frame:Show()
        -- update the UI of the screen
        self:RefreshUI()
    end,

    ---------------------------------------------------------------------------------------
    -- Toggle the frame
    ----------------------------------------------------------------------------------------
    Toggle = function (self)
        if self:IsShown() then
            self:Hide()
        else
            self:Show()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Check if frame is shown/visible
    --
    -- returns		boolean      Visibility of the frame
    ----------------------------------------------------------------------------------------------------------
    IsShown = function(self)
        return self.ui_frame:IsVisible()
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingTradeSkillFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_MissingTradeSkillsFrame", MTSLUI_TOGGLE_BUTTON.ui_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, true)
        -- Set Position relative to MTSL button
        self.ui_frame:SetPoint("TOPLEFT", MTSLUI_TOGGLE_BUTTON.ui_frame, "TOPRIGHT", -2, 0)
        -- Dummy operation to do nothing, discarding the zooming in/out
        self.ui_frame:SetScript("OnMouseWheel", function()
            local x = 1
        end)
        self.ui_frame:Hide()

        -- Create the frames inside this frame
        MTSLUI_MTSLF_TITLE_FRAME:Initialise(self.ui_frame)
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:Initialise(self.ui_frame)
        MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:Initialise(self.ui_frame)
        MTSLUI_MTSLF_PROGRESSBAR:Initialise(self.ui_frame)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Refresh the ui of the addon
    ----------------------------------------------------------------------------------------------------------
    RefreshUI = function (self)
        -- only refresh if this window is visible & if we have learend a skill or swapped tradeskill
        if self:IsShown() then
            if self.prev_tradeskill_name ~= MTSL_CURRENT_TRADESKILL.NAME or
                self.prev_amount_missing ~= MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING then
                -- Refresh the UI frame showing the list of skill
                MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:UpdateList()
                -- Update the progressbar on bottom
                local skills_max_amount = MTSL_TOOLS:GetTotalNumberOfSkillsCurrentTradeskill() + MTSL_DATA.TRADESKILL_LEVELS
                MTSLUI_MTSLF_PROGRESSBAR:UpdateStatusbar(MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING, skills_max_amount)
                self:NoSkillSelected()
            end
            self.prev_tradeskill_name = MTSL_CURRENT_TRADESKILL.NAME
            self.prev_amount_missing = MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING
            -- if we miss skills, auto select first one (only do if we dont have one selected)
            if not MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:HasSkillSelected() or not MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:StillMissingSkill() then
                MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:HandleSelectedListItem(1)
            end
        end
    end,

    --------------------------------
    -- When no skill is selected
    -------------------------------
    NoSkillSelected = function (self)
        MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME:DeselectCurrentSkillButton()
        MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:ShowNoSkillSelected()
    end
}
