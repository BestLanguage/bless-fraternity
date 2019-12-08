----------------------------------------------------------------------------------
-- Name: MissingSkillsListFrame													--
-- Description: Shows the missing skills (order from low to high on min_skill)  --
-- Parent Frame: MissingTradeSkillsListFrame									--
-- Container for:																--
--					SkillButton													--
--					VerticalSlider												--
----------------------------------------------------------------------------------

MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- Maximum amount of items shown at once
    MAX_ITEMS_SHOWN = 20,
    ITEM_HEIGHT = 19,
    -- array holding the buttons of this frame
    SKILLS_BUTTONS,
    -- Offset in the list (based on slider)
    slider_offset = 1,
    -- index and id of the selected skill
    selected_skill_index,
    selected_skill_id,
    -- index of the selected button
    selected_button_index,
    -- Flag to check if slider is active or not
    slider_active,
    -- width of the frame
    FRAME_WIDTH = 345,
    -- height of the frame
    FRAME_HEIGHT = 392,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateScrollFrame(self, parent_frame, self.FRAME_WIDTH, self.FRAME_HEIGHT, true, self.ITEM_HEIGHT)
        -- position under TitleFrame and above MissingSkillsListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLUI_MTSLF_TITLE_FRAME.ui_frame, "BOTTOMLEFT", -1, 0)
        -- Create the buttons
        self.SKILLS_BUTTONS = {}
        local left = 6
        local top = -6
        for i=1,self.MAX_ITEMS_SHOWN do
            -- Create a new list item (button) by making a copy of MTSLUI_LIST_ITEM
            local skill_button = MTSL_TOOLS:CopyObject(MTSLUI_LIST_ITEM)
            skill_button:Initialise(i, self, self.FRAME_WIDTH - 12, self.ITEM_HEIGHT, left, top)
            -- adjust top position for next button
            top = top - self.ITEM_HEIGHT
            -- add button to list
            table.insert(self.SKILLS_BUTTONS, skill_button)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the list of MissingSkillsListFrame
    ----------------------------------------------------------------------------------------------------------
    UpdateList = function (self)
        -- No need for slider
        if MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING <= self.MAX_ITEMS_SHOWN then
            self.slider_active = 0
            self.ui_frame.slider:Hide()
        else
            self.slider_active = 1
            local max_steps = MTSL_CURRENT_TRADESKILL.AMOUNT_MISSING - self.MAX_ITEMS_SHOWN + 1
            self.ui_frame.slider:Refresh(max_steps, self.MAX_ITEMS_SHOWN)
            self.ui_frame.slider:Show()
        end
        self:UpdateButtons()
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the skillbuttons of MissingSkillsListFrame
    ----------------------------------------------------------------------------------------------------------
    UpdateButtons = function (self)
        for i=1,self.MAX_ITEMS_SHOWN do
            -- 1 cause offset starts at 1 too, 
            local skill_for_button = MTSL_MISSING_TRADESKILLS[i + self.slider_offset - 1]
            -- Check if button has text to display, otherwise hide it
            if skill_for_button ~= nil then
                -- create the text to be shown
                local text_for_button = MTSLUI_FONTS.COLORS.AVAILABLE.YES
                if skill_for_button.min_skill > MTSL_CURRENT_TRADESKILL.SKILL_LEVEL then
                    text_for_button =  MTSLUI_FONTS.COLORS.AVAILABLE.NO
                end
                text_for_button = text_for_button .. "[" .. skill_for_button.min_skill .. "] " .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. skill_for_button["name"][MTSL_CURRENT_LANGUAGE]
                -- update & show the button
                self.SKILLS_BUTTONS[i]:Refresh(text_for_button, self.slider_active)
                self.SKILLS_BUTTONS[i]:Show()
                -- button is unavaible so hide it
            else
                self.SKILLS_BUTTONS[i]:Hide()
            end
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles the event when skill button is pushed
    --
    -- @id		Number		The id (= index) of button that is pushed
    ----------------------------------------------------------------------------------------------------------
    HandleSelectedListItem = function(self, id)
        -- Clicked on same button so deselect it
        if self.SKILLS_BUTTONS[id]:IsSelected() == 1 then
            self.selected_skill_index = nil
            self.selected_skill_id = nil
            self.selected_button_index = nil
            self.SKILLS_BUTTONS[id]:Deselect()
            MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:ShowNoSkillSelected()
        else
            -- Deselect the current button if visible
            self:DeselectCurrentSkillButton()
            -- update the index of selected button
            self.selected_button_index = id
            self:SelectCurrentSkillButton()
            -- Subtract 1 because index starts at 1 instead of 0
            self.selected_skill_index = self.slider_offset + id - 1
            -- Show the information of the selected skill
            local selected_skill = MTSL_TOOLS:GetMissingSkillCurrentTradeSkillByIndex(self.selected_skill_index)
            MTSLUI_MTSLF_DETAILS_SELECTED_SKILL_FRAME:ShowDetailsOfSkill(selected_skill)
            self.selected_skill_id = selected_skill.id
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles the event when we scroll
    --
    -- @offset	Number
    ----------------------------------------------------------------------------------------------------------
    HandleScrollEvent = function (self, offset)
        -- Only handle the event if slider is visible
        if self.slider_active == 1 then
            -- Update the index of the selected skill if any
            if self.selected_skill_index ~= nil then
                -- Deselect the current button if visible
                self:DeselectCurrentSkillButton()
                -- adjust index of the selected skill in the list
                local scroll_gap = offset - self.slider_offset
                self.selected_skill_index = self.selected_skill_index - scroll_gap
                self.selected_button_index = self.selected_button_index - scroll_gap
                -- Select the current button if visible
                self:SelectCurrentSkillButton()
                -- scrolled of screen so remove selected id
                if self.selected_button_index < 1 or self.selected_button_index > self.MAX_ITEMS_SHOWN then
                    self.selected_skill_id = nil
                end
            end
            -- Update the offset for the slider
            self.slider_offset = offset
            -- update the text on the buttons based on the new "visible" skills
            self:UpdateButtons()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- reset the position of the scroll bar & deselect current skill
    ----------------------------------------------------------------------------------------------------------
    Reset = function(self)
        -- dselect current skill & button
        self:DeselectCurrentSkillButton()
        self.selected_skill_index = nil
        self.selected_button_index = nil
        self.selected_skill_id = nil
        -- Scroll all way to top
        self:HandleScrollEvent(1)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Selects the current selected skillbuton
    ----------------------------------------------------------------------------------------------------------
    SelectCurrentSkillButton = function (self)
        if self.selected_button_index ~= nil and
                self.selected_button_index >= 1 and
                self.selected_button_index <= self.MAX_ITEMS_SHOWN then
            self.SKILLS_BUTTONS[self.selected_button_index]:Select()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Deselects the current selected skillbuton
    ----------------------------------------------------------------------------------------------------------
    DeselectCurrentSkillButton = function (self)
        if self.selected_button_index ~= nil and
                self.selected_button_index >= 1 and
                self.selected_button_index <= self.MAX_ITEMS_SHOWN then
            self.SKILLS_BUTTONS[self.selected_button_index]:Deselect()
        end
    end,

    -- To see if we have a skill selected or not
    HasSkillSelected = function(self)
        return self.selected_skill_id ~= nil
    end,

    -- Checks if player is still missing the selected skill
    StillMissingSkill = function (self)
        if self.selected_skill_id ~= nil then
            return not IsSpellKnown(self.selected_skill_id)
        end
        return true
    end,
}