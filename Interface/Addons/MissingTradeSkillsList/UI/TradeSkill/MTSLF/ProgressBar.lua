------------------------------------------------------------------
-- Name: ProgressBar											--
-- Description: Contains all functionality for the progressbar	--
-- Parent Frame: MissingTradeSkillsListFrame					--
------------------------------------------------------------------

MTSLUI_MTSLF_PROGRESSBAR = {
    ui_frame,
    FRAME_WIDTH = 855,
    FRAME_HEIGHT = 24,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises  the progressbar
    ----------------------------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_MTSLF_ProgressBar", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT)
        -- Position at bottom of MissingTradeSkillsListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLUI_MTSLF_MISSING_SKILLS_LIST_FRAME.ui_frame, "BOTTOMLEFT", 4, 0)
        local text = MTSLUI_FONTS.COLORS.TEXT.TITLE .. "Missing Skills:"
        self.ui_frame.text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, text, 5, 0, "NORMAL", "LEFT")

        self.ui_frame.progressbar = MTSL_TOOLS:CopyObject(MTSLUI_PROGRESSBAR)
        -- Update the parent frame & position of the generic progressbar
        self.ui_frame.progressbar:Initialise(self.ui_frame, "MTSLUI_MTSLF_ProgressBar", self.FRAME_WIDTH - 90, self.FRAME_HEIGHT, 88)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the values shown on the progressbar
    --
    -- @skills_learned		number		The amount of skills learned for the current tradeskill
    -- @max_skills			number		The maximum amount of skills to be learned for the current tradeskill
    ----------------------------------------------------------------------------------------------------------
    UpdateStatusbar = function (self, skills_learned, max_skills)
        self.ui_frame.progressbar:UpdateStatusbar(1, max_skills, skills_learned)
    end
}