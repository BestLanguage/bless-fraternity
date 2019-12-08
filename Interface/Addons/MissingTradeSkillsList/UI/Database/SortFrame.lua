----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLDBUI_SORT_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- width of the frame
    FRAME_WIDTH = 345,
    -- height of the frame
    FRAME_HEIGHT = 30,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- create the container frame
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and right of ProfessionListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLDBUI_PROFESSION_LIST_FRAME.ui_frame, "TOPRIGHT", 5, 5)
        -- create the sort frame with text and 2 buttons
        self.ui_frame.text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "Sort By", 3, 0, "LARGE", "LEFT")
        self.ui_frame.sort_by_name = self:CreateSortButton("Skill name", true)
        self.ui_frame.sort_by_name:SetPoint("TOPLEFT", self.ui_frame.text, "TOPRIGHT", 15, 5)
        self.ui_frame.sort_by_skill = self:CreateSortButton("Skill level", false)
        self.ui_frame.sort_by_skill:SetPoint("TOPLEFT", self.ui_frame.sort_by_name, "TOPRIGHT", 15, 0)
    end,

    -- Creates a button that allows sorting to be triggered
    CreateSortButton = function(self, text, sort_by_name)
        -- Create the button:
        local button = MTSLUI_TOOLS:CreateBaseFrame("Button", "", self.ui_frame, "UIPanelButtonTemplate", 100, 20)
        button:SetText(text)
        button:SetScript("OnClick", function ()
           MTSLDBUI_SKILL_LIST_FRAME:SortSkills(sort_by_name)
        end)
        return button
    end,
}