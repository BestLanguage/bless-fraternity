------------------------------------------------------------------
-- Name: TitleFrame											    --
-- Description: The tile frame of the databasefame				--
-- Parent Frame: DatabaseFrame              					--
------------------------------------------------------------------

MTSLACCUI_TITLE_FRAME = {
    FRAME_HEIGHT = 30,

    ---------------------------------------------------------------------------------------
    -- Initialises the titleframe
    ----------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.FRAME_WIDTH = MTSLACCUI_ACCOUNT_FRAME.FRAME_WIDTH
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLACCUI_TitleFrame", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        self.ui_frame:SetPoint("TOPLEFT", parent_frame, "TOPLEFT", 0, 0)
        -- Title text
        local title_text = MTSLUI_FONTS.COLORS.TEXT.TITLE ..MTSL_ADDON.NAME .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. " (by " .. MTSL_ADDON.AUTHOR .. ") " .. MTSLUI_FONTS.COLORS.TEXT.TITLE  .. "v" .. MTSL_ADDON.VERSION .. MTSLUI_FONTS.COLORS.TEXT.NORMAL .. " - Account explorer"
        self.ui_frame.text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, title_text, 0, 0, "LARGE", "CENTER")
    end
}