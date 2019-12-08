------------------------------------------------------------------
-- Name: TitleFrame											    --
-- Description: The tile frame of the databasefame				--
-- Parent Frame: DatabaseFrame              					--
------------------------------------------------------------------

MTSLACCUI_CHARACTERS_LIST_FRAME = {
    FRAME_WIDTH = 305,
    FRAME_HEIGHT = 387,
    -- array holding the buttons of this frame
    PLAYER_BUTTONS,
    -- Offset in the list (based on slider)
    slider_offset = 1,
    -- index of the selecter player
    selected_player_index,
    -- index of the selected button
    selected_button_index,
    -- Flag to check if slider is active or not
    slider_active,
    -- Maximum amount of items shown at once
    MAX_ITEMS_SHOWN = 20,
    ITEM_HEIGHT = 19,
    -- array containing all the players (regardless the relam)
    PLAYERS,
    -- flag indication sorting direction
    current_sort_by_name,

    ---------------------------------------------------------------------------------------
    -- Initialises the titleframe
    ----------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, true)
        -- position under TitleFrame and left of SkillDetailFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLACCUI_CHARACTERS_LIST_SORT_FRAME.ui_frame, "BOTTOMLEFT", 0, 0)
        self.init_players = 0
        -- default sorted by realm
        self.current_sort_by_name = false
        self.slider_active = 0
    end,

    ---------------------------------------------------------------------------------------
    -- Refrehs the UI (when new skill is selected)
    --
    -- @trade_skill_name    String      Name of the tradeskill for which to show char status
    -- @skill_id            Number      The number of the skill for which to show char status
    ----------------------------------------------------------------------------------------
    RefreshUI = function(self)
        if self.init_players == 0 then
            -- Create the buttons
            self.PLAYER_BUTTONS = {}
            local left = 6
            local top = -6
            -- create the list items for the skills
            for i=1,self.MAX_ITEMS_SHOWN do
                -- Create a new list item (button) by making a copy of MTSLUI_LIST_ITEM
                local player_button = MTSL_TOOLS:CopyObject(MTSLUI_LIST_ITEM)
                player_button:Initialise(i, self, self.FRAME_WIDTH - 14, self.ITEM_HEIGHT, left, top)
                -- adjust top position for next button
                top = top - self.ITEM_HEIGHT
                -- add button to list
                table.insert(self.PLAYER_BUTTONS, player_button)
            end
            -- add all players to this tabel but remove the "level" of realm
            self.PLAYERS = {}
            for k, realm in pairs(MTSL_PLAYERS) do
                for l, player in pairs(realm) do
                    table.insert(self.PLAYERS, player)
                end
            end
            self:UpdatePlayers()
        end
        -- if we have players, select the first one
        self:HandleSelectedListItem(1)
    end,
    -----------------------
    -----------------------------------------------------------------------------------
    -- Updates the skillbuttons of MissingSkillsListFrame
    ----------------------------------------------------------------------------------------------------------
    UpdatePlayers = function (self)
        for i=1,self.MAX_ITEMS_SHOWN do
            -- 1 cause offset starts at 1 too,
            local selected_player = self.PLAYERS[i + self.slider_offset - 1]
            -- Check if button has text to display, otherwise hide it
            if selected_player ~= nil then
                -- create the text to be shown
                local text_for_button = MTSLUI_FONTS.COLORS.FACTION[string.upper(selected_player.FACTION)] .. selected_player.NAME .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. " (".. selected_player.REALM .. ")"
                -- update & show the button
                self.PLAYER_BUTTONS[i]:Refresh(text_for_button, self.slider_active)
                self.PLAYER_BUTTONS[i]:Show()
                -- button is unavaible so hide it
            else
                self.PLAYER_BUTTONS[i]:Hide()
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
            self:DeselectCurrentPlayerButton()
            -- update the index of selected button
            self.selected_button_index = id
            self:SelectCurrentPlayerButton()
            -- Subtract 1 because index starts at 1 instead of 0
            self.selected_player_index = self.slider_offset + id - 1
            -- Show the information of the selected skill
            local selected_player = self.PLAYERS[self.selected_player_index]
            MTSLACCUI_PROFESSION_LIST_FRAME:UpdateList(selected_player)
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Sorting the list in the frame
    ----------------------------------------------------------------------------------------------------------
    SortPlayers = function(self, sort_by_name)
        -- Only update list if we swap sorting method
        if self.current_sort_by_name ~= sort_by_name then
            if sort_by_name then
                table.sort(self.PLAYERS, function(a, b) return a.NAME < b.NAME end)
            else
                -- sorting by realm
                table.sort(self.PLAYERS, function(a, b) return a.REALM < b.REALM end)
            end
            self.current_sort_by_name = sort_by_name
            self:UpdatePlayers()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- reset the position of the scroll bar & deselect current skill
    ----------------------------------------------------------------------------------------------------------
    Reset = function(self)
        -- dselect current skill & button
        self:DeselectCurrentSkillButton()
        self.selected_player_index = nil
        self.selected_button_index = nil
        -- Scroll all way to top
        self:HandleScrollEvent(1)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Selects the current selected skillbuton
    ----------------------------------------------------------------------------------------------------------
    SelectCurrentPlayerButton = function (self)
        if self.selected_button_index ~= nil and
                self.selected_button_index >= 1 and
                self.selected_button_index <= self.MAX_ITEMS_SHOWN then
            self.PLAYER_BUTTONS[self.selected_button_index]:Select()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Deselects the current selected skillbuton
    ----------------------------------------------------------------------------------------------------------
    DeselectCurrentPlayerButton = function (self)
        if self.selected_button_index ~= nil and
                self.selected_button_index >= 1 and
                self.selected_button_index <= self.MAX_ITEMS_SHOWN then
            self.PLAYER_BUTTONS[self.selected_button_index]:Deselect()
        end
    end,
}