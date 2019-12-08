----------------------------------------------------------------------------------
-- Name: ProfessionListFrame													--
-- Description: Shows available professions in the MTSL database                --
-- Parent Frame: DatabaseFrame              									--
----------------------------------------------------------------------------------

MTSLDBUI_PROFESSION_LIST_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- height of an item to select in the list
    ITEM_HEIGHT = 46,
    -- width of the frame
    FRAME_WIDTH = 45,
    -- height of the frame
    FRAME_HEIGHT = 415,
    selected_index,

----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- container frame (no scroll
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and above MissingSkillsListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLDBUI_TITLE_FRAME.ui_frame, "BOTTOMLEFT", 3, 0)
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
            local skill_button = self:CreateProfessionButton(self.ui_frame, "MTSLDBUI_PROF_BTN_"..i, i)
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
            MTSLDBUI_PROFESSION_LIST_FRAME:HandleSelectedListItem(i)
        end)
        return button
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
            -- show the new selected border
            local profession_name = MTSL_NAME_PROFESSIONS[id]
            MTSLDBUI_SKILL_LIST_FRAME:ChangeProfession(profession_name)
        end
    end,
}