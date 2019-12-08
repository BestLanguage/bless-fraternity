----------------------------------------------------------
-- Name: SkillListFrame									--
-- Description: Shows all the skills for one profession --
-- Parent Frame: DatabaseFrame							--
----------------------------------------------------------

MTSLACCUI_SKILL_LIST_SORT_FRAME = {
    -- Keeps the current created frame
    ui_frame,
    -- width of the frame
    FRAME_WIDTH = 345,
    -- height of the frame
    FRAME_HEIGHT = 25,
    --FRAME_HEIGHT = 45,
    -- keep the current continent and zone we filter
    current_cont,
    current_zone,
    -- flag to prevent keep on init drop down list
    drop_down_init,
    ----------------------------------------------------------------------------------------------------------
    -- Intialises the MissingSkillsListFrame
    --
    -- @parent_frame		Frame		The parent frame
    ----------------------------------------------------------------------------------------------------------
    Initialise = function(self, parent_frame)
        -- create the container frame
        self.ui_frame = MTSLUI_TOOLS:CreateBaseFrame("Frame", "", parent_frame, nil, self.FRAME_WIDTH, self.FRAME_HEIGHT, false)
        -- position under TitleFrame and right of ProfessionListFrame
        self.ui_frame:SetPoint("TOPLEFT", MTSLACCUI_PROFESSION_LIST_FRAME.ui_frame, "TOPRIGHT", 0, 0)
        -- create the sort frame with text and 2 buttons
        self.ui_frame.sort_by_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "Sort By", 5, -5, "LARGE", "TOPLEFT")
        self.ui_frame.sort_by_name = self:CreateSortButton("Skill name", true)
        self.ui_frame.sort_by_name:SetPoint("TOPLEFT", self.ui_frame.sort_by_text, "TOPRIGHT", 15, 5)
        self.ui_frame.sort_by_skill = self:CreateSortButton("Skill level", false)
        self.ui_frame.sort_by_skill:SetPoint("TOPLEFT", self.ui_frame.sort_by_name, "TOPRIGHT", 15, 0)
        -- create a filter for the zones
     --   self.ui_frame.zone_text = MTSLUI_TOOLS:CreateLabel(self.ui_frame, "Zone", 5, 5, "LARGE", "BOTTOMLEFT")
        -- Continent (Too many zones too show just all)
     --   self.ui_frame.cont_zone_drop_down = CreateFrame("Frame", "", self.ui_frame.sort_by_name, "UIDropDownMenuTemplate")
     --   self.ui_frame.cont_zone_drop_down:SetPoint("TOPLEFT", self.ui_frame.sort_by_name, "BOTTOMLEFT", -30, 1)
     --   self.ui_frame:SetScript("OnLoad", function()
     --       MTSLACCUI_PROFESSION_LIST_FRAME:CreateDropDown()
     --   end)
    end,

    CreateDropDown = function(self)
        if self.drop_down_init == 0 then
            UIDropDownMenu_Initialize(self.ui_frame.cont_zone_drop_down, self.CreateContinentsAndZones)
            UIDropDownMenu_SetWidth(self.ui_frame.cont_zone_drop_down, 250)
            UIDropDownMenu_SetText(self.ui_frame.cont_zone_drop_down, "All")
        end
        self.drop_down_init = 1
    end,

    CreateContinentsAndZones = function(self)
        local conts = MTSL_TOOLS:GetContintents()
        -- Create the toplevel with contintents
        local info = UIDropDownMenu_CreateInfo()
        -- Add the "any option"
        info.text = "All"
        info.func = MTSLACCUI_SKILL_LIST_SORT_FRAME.ChangeContinentsToAll
        -- default option
        info.notCheckable = false;
        UIDropDownMenu_AddButton(info)
        -- Add an option for each zone
        for a, b in pairs(conts) do
            -- top level has submenu
            info.hasArrow = true;
            info.text = b["name"][MTSL_CURRENT_LANGUAGE]
            -- can not select this top menu
            info.notCheckable = true;
            UIDropDownMenu_AddButton(info)

            local zones = MTSL_TOOLS:GetZonesInContinent(b["name"][MTSL_CURRENT_LANGUAGE])
            print("Adding zones for " .. b["name"][MTSL_CURRENT_LANGUAGE])
            -- Add the zones for this continent
            for k, v in pairs(zones) do
                -- no submenu this time
                info.hasArrow = false;
                info.notCheckable = true;
                info.text = v["name"][MTSL_CURRENT_LANGUAGE]
                info.func = MTSLACCUI_SKILL_LIST_SORT_FRAME.ChangeZone
                UIDropDownMenu_AddButton(info, 2)
            end
        end
    end,

    -- When we select all continents in drop down
    ChangeContinentsToAll = function(self)
        print("Changeing to all contintents")
        CloseDropDownMenus()
    end,

    -- When a zone is selected in the dropdown
    ChangeZone = function(self)
        local new_zone = MTSL_TOOLS:GetZone(self:GetText())
        -- if not null (means we selected "Any")
        if new_zone ~= nil then
            local continent = MTSL_TOOLS:GetContintentById(new_zone["cont_id"])
            print("Changed to " .. new_zone["id"] .. " " .. new_zone["name"][MTSL_CURRENT_LANGUAGE] .. " on " .. new_zone["cont_id"] .. " " .. continent["name"][MTSL_CURRENT_LANGUAGE])
            UIDropDownMenu_SetText(MTSLACCUI_SKILL_LIST_SORT_FRAME.ui_frame.cont_zone_drop_down, continent["name"][MTSL_CURRENT_LANGUAGE] .. " - " .. new_zone["name"][MTSL_CURRENT_LANGUAGE])
        else
            UIDropDownMenu_SetText(MTSLACCUI_SKILL_LIST_SORT_FRAME.ui_frame.cont_zone_drop_down, "Any")
        end
        if self.current_zone_id ~= new_zone["id"]  then
        end

        CloseDropDownMenus()
    end,

    -- Creates a button that allows sorting to be triggered
    CreateSortButton = function(self, text, sort_by_name)
        -- Create the button:
        local button = MTSLUI_TOOLS:CreateBaseFrame("Button", "", self.ui_frame, "UIPanelButtonTemplate", 100, 20)
        button:SetText(text)
        button:SetScript("OnClick", function ()
           MTSLACCUI_SKILL_LIST_FRAME:SortSkills(sort_by_name)
        end)
        return button
    end,
}