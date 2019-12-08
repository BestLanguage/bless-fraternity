------------------------------------------------------------------
-- Name: TitleFrame											    --
-- Description: The tile frame									--
-- Parent Frame: MissingTradeSkillsListFrame					--
------------------------------------------------------------------

MTSLUI_MTSLF_TITLE_FRAME = {
    FRAME_WIDTH = 815,
    FRAME_HEIGHT = 20,

    ---------------------------------------------------------------------------------------
    -- Initialises the titleframe
    ----------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLUI_MTSLF_TitleFrame", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT)
        self.ui_frame:SetPoint("TOPLEFT", parent_frame, "TOPLEFT", 5, -5)
        -- Title text
        local title_text = MTSLUI_FONTS.COLORS.TEXT.TITLE ..MTSL_ADDON.NAME .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. " (by " .. MTSL_ADDON.AUTHOR .. ") " .. MTSLUI_FONTS.COLORS.TEXT.TITLE  .. "v" .. MTSL_ADDON.VERSION
        self.ui_frame.text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, title_text, 0, 0, "LARGE", "CENTER")
    end
}