----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLDBUI_SKILL_LIST_FRAME = {
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
    FRAME_HEIGHT = 422,
    -- save the trade skills info
    trade_skill_name,
    profession_skills,
    amount_profession_sklls,
    -- Sort by name by default
    current_sort_by_name = true,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateScrollFrame(self, parent_frame, self.FRAME_WIDTH, self.FRAME_HEIGHT - 30, true, self.ITEM_HEIGHT)
        -- position under the sort text frame and left of professionlistframe
        self.ui_frame:SetPoint("BOTTOMLEFT", MTSLDBUI_PROFESSION_LIST_FRAME.ui_frame, "BOTTOMRIGHT", 0, 0)
        -- Create the buttons
        self.SKILLS_BUTTONS = {}
        local left = 6
        local top = -6
        -- create the list items for the skills
        for i=1,self.MAX_ITEMS_SHOWN do
            -- Create a new list item (button) by making a copy of MTSLUI_LIST_ITEM
            local skill_button = MTSL_TOOLS:CopyObject(MTSLUI_LIST_ITEM)
            skill_button:Initialise(i, self, self.FRAME_WIDTH - 14, self.ITEM_HEIGHT, left, top)
            -- adjust top position for next button
            top = top - self.ITEM_HEIGHT
            -- add button to list
            table.insert(self.SKILLS_BUTTONS, skill_button)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Change the profession to be used in the list
    ----------------------------------------------------------------------------------------------------------
    ChangeProfession = function(self, trade_skill_name)
        -- Only change if new one
        if self.trade_skill_name ~= trade_skill_name then
            self.trade_skill_name = trade_skill_name
            self:DeselectCurrentSkillButton()
            self.profession_skills = MTSL_TOOLS:GetAllSkillsForProfession(trade_skill_name, self.current_sort_by_name)
            self.amount_profession_sklls = MTSL_TOOLS:CountItemsInArray(self.profession_skills)
            self:UpdateList()
            -- Auto select first skill of the profession
            self.selected_button_index = 0
            self:HandleSelectedListItem(1)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the list of MissingSkillsListFrame
    ----------------------------------------------------------------------------------------------------------
    UpdateList = function (self)
        -- No need for slider
        if self.amount_profession_sklls <= self.MAX_ITEMS_SHOWN then
            self.slider_active = 0
            self.ui_frame.slider:Hide()
        else
            self.slider_active = 1
            local max_steps = self.amount_profession_sklls - self.MAX_ITEMS_SHOWN + 1
            self.ui_frame.slider:Refresh(max_steps, self.MAX_ITEMS_SHOWN)
            self.ui_frame.slider:Show()
        end
        self:UpdateButtons()
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Sorting the list in the frame
    ----------------------------------------------------------------------------------------------------------
    SortSkills = function(self, sort_by_name)
        -- Only update list if we swap sorting method
        if self.current_sort_by_name ~= sort_by_name then
            if sort_by_name then
                self.current_sort_by_name = true
                table.sort(self.profession_skills, function(a, b) return a["name"][MTSL_CURRENT_LANGUAGE] < b["name"][MTSL_CURRENT_LANGUAGE] end)
            else
                self.current_sort_by_name = false
                table.sort(self.profession_skills, function(a, b) return a.min_skill < b.min_skill end)
            end
            self:UpdateList()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the skillbuttons of MissingSkillsListFrame
    ----------------------------------------------------------------------------------------------------------
    UpdateButtons = function (self)
        for i=1,self.MAX_ITEMS_SHOWN do
            -- 1 cause offset starts at 1 too,
            local skill_for_button = self.profession_skills[i + self.slider_offset - 1]
            -- Check if button has text to display, otherwise hide it
            if skill_for_button ~= nil then
                -- create the text to be shown
                local text_for_button = MTSLUI_FONTS.COLORS.TEXT.NORMAL .. "[" .. skill_for_button.min_skill .. "] " .. skill_for_button["name"][MTSL_CURRENT_LANGUAGE]
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
        -- Only refresh shown skill if other one is selected
        if self.selected_button_index ~= id then
            -- Deselect the current button if visible
            self:DeselectCurrentSkillButton()
            -- update the index of selected button
            self.selected_button_index = id
            self:SelectCurrentSkillButton()
            -- Subtract 1 because index starts at 1 instead of 0
            self.selected_skill_index = self.slider_offset + id - 1
            -- Show the information of the selected skill
            local selected_skill = self.profession_skills[self.selected_skill_index]
            MTSLDBUI_SKILL_DETAIL_FRAME:ShowDetailsOfSkill(self.trade_skill_name, selected_skill)
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
}