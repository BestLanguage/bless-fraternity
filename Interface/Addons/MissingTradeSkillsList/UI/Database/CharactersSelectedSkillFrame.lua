------------------------------------------------------------------
-- Name: TitleFrame											    --
-- Description: The tile frame of the databasefame				--
-- Parent Frame: DatabaseFrame              					--
------------------------------------------------------------------

MTSLDBUI_CHARS_SELECTED_SKILL_FRAME = {
    FRAME_WIDTH = 280,
    FRAME_HEIGHT = 420,
    -- holds the translated labels to show
    LOCALE_TEXT = {
        ["English"] = {
            ["KnownBy"] = " is known by ",
            ["Characters"] = " characters!",
            ["TooLowSkill"] = "Needs more skill",
            ["Learnable"] = "Can learn",
            ["Learned"] = "Learned",
        },
        ["French"] = {
            ["KnownBy"] = " est connu par ",
            ["Characters"] = " personnages!",
            ["TooLowSkill"] = "Compétence insuffisante",
            ["Learnable"] = "Apprenable",
            ["Learned"] = "Appris",
        },
        ["German"] = {
            ["KnownBy"] = " ist bekannt durch ",
            ["Characters"] = " Figuren!",
            ["TooLowSkill"] = "Zu wenig Fertigkeit",
            ["Learnable"] = "Lernbar",
            ["Learned"] = "Gelernt",
        },
        ["Spanish"] = {
            ["KnownBy"] = " es conocido por ",
            ["Characters"] = " personajes!",
            ["TooLowSkill"] = "Muy poca habilidad",
            ["Learnable"] = "Aprendible",
            ["Learned"] = "Conocido",
        },
        ["Russian"] = {
            ["KnownBy"] = " is known by ",
            ["Characters"] = " characters!",
            ["TooLowSkill"] = "Needs more skill",
            ["Learnable"] = "Can learn",
            ["Learned"] = "Learned",
        },
    },

    ---------------------------------------------------------------------------------------
    -- Initialises the titleframe
    ----------------------------------------------------------------------------------------
    Initialise = function (self, parent_frame)
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and left of SkillDetailFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLDBUI_SKILL_DETAIL_FRAME.ui_frame, "TOPRIGHT", -3, 0)

        self.title = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_FONTS.COLORS.TEXT.TITLE .. "", 4, -3, "NORMAL", "TOPLEFT")
        self.labels_created = 0

        -- create labels for each realm and each char / realm
        self.char_labels = {}
    end,

    CreateLabels = function(self)
        -- Positions for the labels
        local text_label_left = 4
        local text_label_left_tab = 24
        local text_label_right = 150
        local text_label_top = -30
        local text_label_gap = 15

        for k, realm in pairs(MTSL_PLAYERS) do
            self.char_labels[k]={}
            self.char_labels[k].title_frame = MTSLUI_TOOLS:CreateLabel(self.ui_frame, MTSLUI_FONTS.COLORS.TEXT.TITLE .. k, text_label_left, text_label_top, "SMALL", "TOPLEFT")
            text_label_top = text_label_top - text_label_gap
            for i, player in pairs(realm) do
                local color_faction = MTSLUI_FONTS.COLORS.FACTION[string.upper(player.FACTION)]
                self.char_labels[k][i] = {
                    ["name"] = MTSLUI_TOOLS:CreateLabel(self.ui_frame, color_faction .. i, text_label_left_tab, text_label_top, "SMALL", "TOPLEFT"),
                    ["status"] = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "status", text_label_right, text_label_top, "SMALL", "TOPLEFT"),
                }
                text_label_top = text_label_top - text_label_gap
            end
            -- extra gap between characters and next realm
            text_label_top = text_label_top - text_label_gap
        end
        self.labels_created = 1
    end,

    ---------------------------------------------------------------------------------------
    -- Refrehs the UI (when new skill is selected)
    --
    -- @trade_skill_name    String      Name of the tradeskill for which to show char status
    -- @skill_id            Number      The number of the skill for which to show char status
    ----------------------------------------------------------------------------------------
    RefreshUI = function(self, trade_skill_name, skill_id)
        if self.labels_created == 0 then
            self:CreateLabels()
        end

        -- Positions for the labels
        local text_label_left = 4
        local text_label_left_tab = 24
        local text_label_right = 150
        local text_label_top = -30
        local text_label_gap = 15
        -- counter
        local known_by_chars = 0
        -- colors and text to show status of knowing
        local known_skill_text = {
            MTSLUI_FONTS.COLORS.AVAILABLE.NO .. self:GetLocaleText("TooLowSkill"),   -- can not be learned ( too low skill)
            MTSLUI_FONTS.COLORS.TEXT.WARNING .. self:GetLocaleText("Learnable"),     -- can be learned (skill is high enough)
            MTSLUI_FONTS.COLORS.AVAILABLE.YES .. self:GetLocaleText("Learned"),      -- already learned
        }

        -- loop all the characters
        for k, realm in pairs(MTSL_PLAYERS) do
            self.char_labels[k].title_frame:SetPoint("TOPLEFT", text_label_left, text_label_top)
            self.char_labels[k].title_frame:Show()
            text_label_top = text_label_top - text_label_gap
            local known_before_server = known_by_chars
            for i, player in pairs(realm) do
                -- returns 0 if tade_skill not trained, 1 if trained but skill not learned, 2 if skill is learnable, 3 if skill learned
                local known_status = MTSL_TOOLS:IsSkillKnownForPlayer(player, trade_skill_name, skill_id)
                if known_status > 0 then
                    self.char_labels[k][i].name:SetPoint("TOPLEFT", text_label_left_tab, text_label_top)
                    self.char_labels[k][i].name:Show()
                    self.char_labels[k][i].status:SetText(known_skill_text[known_status])
                    self.char_labels[k][i].status:SetPoint("TOPLEFT", text_label_right, text_label_top)
                    self.char_labels[k][i].status:Show()
                    text_label_top = text_label_top - text_label_gap
                    known_by_chars = known_by_chars + 1
                else
                    self.char_labels[k][i].name:Hide()
                    self.char_labels[k][i].status:Hide()
                end
            end
            -- we did not add any chars on this realm, so hide label and move back up the gap
            if known_before_server == known_by_chars then
                self.char_labels[k].title_frame:Hide()
                text_label_top = text_label_top + text_label_gap
            end

            -- extra gap between characters and next realm
            text_label_top = text_label_top - text_label_gap
        end

        -- update the counter in the label
        self.title:SetText(MTSLUI_FONTS.COLORS.TEXT.TITLE .. self:GetLocaleText(trade_skill_name) .. self:GetLocaleText("KnownBy") .. known_by_chars .. self:GetLocaleText("Characters"))
    end,

    GetLocaleText = function(self, label)
        -- try to find it in this frames labels
        local localised_label = self.LOCALE_TEXT[MTSL_CURRENT_LANGUAGE][label]
        -- if not found  try the general/profession labels
        if localised_label == nil then
            localised_label = MTSL_LOCALES_PROFESSIONS[MTSL_CURRENT_LANGUAGE][label]
        end
        -- if not found show "" and print error
        if localised_label == nil then
            localised_label = ""
            print(MTSLUI_FONTS.COLORS.TEXT.ERROR .. "MTSL: Could not find translation in Frame MTSLDBUI_CHARS_SELECTED_SKILL_FRAME for the label " .. label .. ". Please report this bug!")
        end

        return localised_label
    end,
}