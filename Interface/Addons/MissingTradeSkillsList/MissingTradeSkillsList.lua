---------------------
-- Start the addon --
---------------------

-- Intialise our fonts
MTSLUI_FONTS:Initialise()

-- Initialise our event handler
MTSLUI_EVENT_HANDLER:Initialise()

-- Add slash command for addon & use eventhandler to handle it
SLASH_MTSL1 = "/mtsl"
function SlashCmdList.MTSL (msg, editbox)
    MTSLUI_EVENT_HANDLER:SLASH_COMMAND(msg)
end

-- Create the toggle button (shown on tradeskill/craft window)
MTSLUI_TOGGLE_BUTTON:Initialise()

-- Create the MTSL window expanding tradeskill/craft window)
MTSLUI_MISSING_TRADESKILLS_FRAME:Initialise()

-- Create char window acountwide (Disabled for now)
MTSLACCUI_ACCOUNT_FRAME:Initialise()

-- Create database explorer window
MTSLDBUI_DATABASE_FRAME:Initialise()