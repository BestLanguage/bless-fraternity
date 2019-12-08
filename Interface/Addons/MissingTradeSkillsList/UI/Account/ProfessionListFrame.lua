----------------------------------------------------------------------------------
-- Name: ProfessionListFrame													--
-- Description: Shows available professions in the MTSL database                --
-- Parent Frame: DatabaseFrame              									--
----------------------------------------------------------------------------------

MTSLACCUI_PROFESSION_LIST_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- height of an item to select in the list
    ITEM_HEIGHT = 45,
    -- width of the frame
    FRAME_WIDTH = 45,
    -- height of the frame
    FRAME_HEIGHT = 415,
    selected_index,
    -- hold the selected player
    selected_player_tradeskills,

----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- container frame (no scroll
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and left of MTSLACCUI_CHARACTERS_LIST_FRAME
        self.ui_frame:SetPoint("TOPLEFT", MTSLACCUI_CHARACTERS_LIST_SORT_FRAME.ui_frame, "TOPRIGHT", -3, -3)
        -- Create the background frames for the buttons
        self.PROF_BGS = {}
        -- Create the buttons
        self.PROF_BUTTONS = {}
        local left = 9
        local top = -2
        local i = 1
        while MTSL_NAME_PROFESSIONS[i] ~= nil do
            -- create background frame
            local bg_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", self.ui_frame, nil, self.FRAME_WIDTH + 1, self.ITEM_HEIGHT + 5, true)
            -- yellow border & transparant fill
            bg_frame:SetBackdropColor(1, 1, 0, 0.40)
            bg_frame:SetBackdropBorderColor(1, 1, 0, 1)
            bg_frame:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", 1, top + 5)
            -- hide on create
            bg_frame:Hide()
            table.insert(self.PROF_BGS, bg_frame)
            -- Create a new list item (button) by making a copy of MTSLUI_LIST_ITEM
            local skill_button = self:CreateProfessionButton(self.ui_frame, "MTSLACCUI_PROF_BTN_"..i, i)
            skill_button:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", left, top)
            -- adjust top position for next button
            top = top - self.ITEM_HEIGHT
            -- add button to list
            table.insert(self.PROF_BUTTONS, skill_button)
            -- Show label with amount of skills for this profession
            local title_text = MTSL_DATA.AMOUNT_SKILLS[MTSL_NAME_PROFESSIONS[i]] + MTSL_DATA.TRADESKILL_LEVELS
            skill_button.text = MTSLUI_TOOLS:CreateLabel(skill_button, title_text, 0, -12, "NORMAL", "BOTTOM")

            i = i + 1
        end
    end,

    -- Create a button to represent a profession
    CreateProfessionButton = function(self, parent_frame, name, i)
        -- Create the button:
        local button = CreateFrame("Button", name, parent_frame, "")
        button:SetSize(30, 30)
        -- Add the icon:
        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetAllPoints(true)
        icon:SetTexture(MTSL_ICONS_PROFESSION[MTSL_NAME_PROFESSIONS[i]])
        button.icon = icon

        button:SetScript("OnClick", function ()
            MTSLACCUI_PROFESSION_LIST_FRAME:HandleSelectedListItem(i)
        end)
        return button
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the list of ProfessionListFrame (when choosing new player)
    ----------------------------------------------------------------------------------------------------------
    UpdateList = function (self, selected_player)
        -- loop the know professions
        self.selected_player_tradeskills = selected_player.TRADESKILLS

        local first_button_shown = 0
        if self.selected_player_tradeskills ~= {} and self.selected_player_tradeskills ~= nil then
            local left = 9
            local top = -2
            local i = 1
            while MTSL_NAME_PROFESSIONS[i] ~= nil do
                if self.selected_player_tradeskills[MTSL_NAME_PROFESSIONS[i]] ~= nil and self.selected_player_tradeskills[MTSL_NAME_PROFESSIONS[i]] ~= 0 then
                    self.PROF_BGS[i]:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", 1, top + 5)
                    self.PROF_BUTTONS[i]:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", left, top)
                    self.PROF_BUTTONS[i]:Show()
                    top = top - self.ITEM_HEIGHT
                    if first_button_shown == 0 then
                        first_button_shown = i
                    end
                else
                    self.PROF_BGS[i]:Hide()
                    self.PROF_BUTTONS[i]:Hide()
                end
                i = i + 1
            end
        else
            local i = 1
            -- has no skills so hide evertyhing
            while MTSL_NAME_PROFESSIONS[i] ~= nil do
                self.PROF_BGS[i]:Hide()
                self.PROF_BUTTONS[i]:Hide()
                i = i + 1
            end
        end
        -- Auto click/select first profession/button if possible
        if first_button_shown > 0 then
            self:HandleSelectedListItem(first_button_shown)
        --nothing to select so clear detail screen
        else
            self.selected_index = nil
            MTSLACCUI_SKILL_LIST_FRAME:NoSkillsToShow()
            MTSLACCUI_SKILL_DETAIL_FRAME:ShowNoSkillSelected()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Handles the event when skill button is pushed
    --
    -- @id		Number		The id (= index) of button that is pushed
    ----------------------------------------------------------------------------------------------------------
    HandleSelectedListItem = function(self, id)
        -- only change if we selected a new profession
        if self.selected_index ~= id then
            -- Deselect the old BG_Frame by hiding it
            if self.selected_index ~= nil then
                self.PROF_BGS[self.selected_index]:Hide()
            end
            self.selected_index = id
            self.PROF_BGS[self.selected_index]:Show()
            local profession_name = MTSL_NAME_PROFESSIONS[id]
            MTSLACCUI_SKILL_LIST_FRAME:ChangeProfession(profession_name, self.selected_player_tradeskills[profession_name].MISSING_SKILLS)
        end
    end,
}