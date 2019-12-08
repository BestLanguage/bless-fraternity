-- This is a file exclusively for debug channels and functions. On a release build, debug statements are no-op and ignored.
-- This file will exist on a release build so Debug related code in the other files is defined.
local Addon, L = _G[select(1,...).."_GET"]()



-- Debug print. On a release build this does nothing.
function Addon:Debug(msg, ...)
    --[===[@debug@
    if not self:IsDebug() then return end
    self:Print(msg, ...)
    --@end-debug@]===]
end

-- Debug print function for rules
function Addon:DebugRules(msg, ...)
    --[===[@debug@
    if (self:IsDebugRules()) then
        self:Print(" %s[Rules]%s " .. msg, ACHIEVEMENT_COLOR_CODE, FONT_COLOR_CODE_CLOSE, ...)
    end
    --@end-debug@]===]
end


