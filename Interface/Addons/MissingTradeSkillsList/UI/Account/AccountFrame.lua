-----------------------------------------------------------------
-- Name: MissingTradeSkillFrame			                           --
-- Description: The main frame shown next to TradeSkill window --
-----------------------------------------------------------------
MTSLACCUI_ACCOUNT_FRAME = {
    ui_frame = nil,
    -- Addon frame
    FRAME_WIDTH = 1215,
    FRAME_HEIGHT = 450,

    ---------------------------------------------------------------------------------------
    -- Hides the frame
    ----------------------------------------------------------------------------------------
    Hide = function (self)
        self.ui_frame:Hide()
    end,

    ---------------------------------------------------------------------------------------
    -- Shows the frame
    ----------------------------------------------------------------------------------------
    Show = function (self)
        -- hide database viewer
        MTSLDBUI_DATABASE_FRAME:Hide()
        self.ui_frame:Show()
        -- update the UI of the screen
        self:RefreshUI()
    end,

    ---------------------------------------------------------------------------------------
    -- Toggle the frame
    ----------------------------------------------------------------------------------------
    Toggle = function (self)
        if self:IsShown() then
            self:Hide()
        else
            self:Show()
        end
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Check if frame is shown/visible
    --
    -- returns		boolean      Visibility of the frame
    ----------------------------------------------------------------------------------------------------------
    IsShown = function(self)
        return self.ui_frame:IsVisible()
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingTradeSkillFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "MTSLACCUI_AccountFrame", nil, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, true)
        self.ui_frame:SetScale(MTSLUI_TOOLS:GetScale())
        -- Set Position to center of screen
        self.ui_frame:SetPoint("CENTER", nil, "CENTER", 0, 0)
        -- Dummy operation to do nothing, discarding the zooming in/out
        self.ui_frame:SetScript("OnMouseWheel", function()
            local x = 1
        end)
        -- add the close button
        self.ui_frame.close_button = MTSLUI_TOOLS:CreateBaseFrame("Button", "", self.ui_frame, "UIPanelButtonTemplate", 24, 24)
        self.ui_frame.close_button:SetText("X")
        -- Set Position to top right of databaseframe
        self.ui_frame.close_button:SetPoint("TOPRIGHT", self.ui_frame, "TOPRIGHT", -2, -2)
        self.ui_frame.close_button:SetScript("OnClick", function()
            MTSLACCUI_ACCOUNT_FRAME:Hide()
        end)
        -- Hide oncreation
        self.ui_frame:Hide()

        -- Create the frames inside this frame
        MTSLACCUI_TITLE_FRAME:Initialise(self.ui_frame)
        MTSLACCUI_CHARACTERS_LIST_SORT_FRAME:Initialise(self.ui_frame)
        MTSLACCUI_CHARACTERS_LIST_FRAME:Initialise(self.ui_frame)
        MTSLACCUI_PROFESSION_LIST_FRAME:Initialise(self.ui_frame)
        MTSLACCUI_SKILL_LIST_SORT_FRAME:Initialise(self.ui_frame)
        MTSLACCUI_SKILL_LIST_FRAME:Initialise(self.ui_frame)
        MTSLACCUI_SKILL_DETAIL_FRAME:Initialise(self.ui_frame)
    end,

    ----------------------------------------------------------------------------------------------------------
    -- Refresh the ui of the addon
    ----------------------------------------------------------------------------------------------------------
    RefreshUI = function (self)
        MTSLACCUI_CHARACTERS_LIST_FRAME:RefreshUI()
    end,
}
