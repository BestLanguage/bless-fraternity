------------------------------------------------------------------
-- Name: ProgressBar											--
-- Description: Contains all functionality for the progressbar	--
-- Parent Frame: MissingTradeSkillsListFrame					--
------------------------------------------------------------------

MTSLUI_PROGRESSBAR = {
    ui_frame = {},
    FRAME_WIDTH,
    FRAME_HEIGHT,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises  the progressbar
    ----------------------------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame, name, width, height, left_gap_to_parent_frame)
        self.FRAME_WIDTH = width
        self.FRAME_HEIGHT = height
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", name .. "_frame", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        self.ui_frame:SetPoint("TOPLEFT", parent_frame, "TOPLEFT", left_gap_to_parent_frame, 0)

        self.ui_frame.texture = MTSLUI_TOOLS:CreateBaseFrame("Statusbar", name .. "_Texture", self.ui_frame, nil, self.FRAME_WIDTH - 8, self.FRAME_HEIGHT - 8, false)
        self.ui_frame.texture:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", 4, -4)
        self.ui_frame.texture:SetStatusBarTexture("Interface/PaperDollInfoFrame/UI-Character-Skills-Bar")

        self.ui_frame.counter = MTSLUI_TOOLS:CreateBaseFrame("Frame",  name .. "_Counter",  self.ui_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, true)
        self.ui_frame.counter:SetPoint("TOPLEFT", self.ui_frame, "TOPLEFT", 0, 0)
        -- Status text
        self.ui_frame.counter.text = MTSLUI_TOOLS:CreateLabel(self.ui_frame.counter, "", 0, 0, "NORMAL", "CENTER")
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Updates the values shown on the progressbar
    --
    -- @min_value		number
    -- @max_value		number
    -- @current_value   number
    ----------------------------------------------------------------------------------------------------------
    UpdateStatusbar = function (self, min_value, max_value, current_value)
        self.ui_frame.texture:SetMinMaxValues(min_value, max_value)
        self.ui_frame.texture:SetValue(current_value)
        self.ui_frame.texture:SetStatusBarColor(0.0, 1.0, 0.0, 0.95)
        self.ui_frame.counter.text:SetText(MTSLUI_FONTS.COLORS.TEXT.NORMAL .. current_value .. "/" .. max_value)
    end,
}