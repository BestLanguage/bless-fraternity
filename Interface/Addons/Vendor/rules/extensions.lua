--[[===========================================================================
    | Copyright (c) 2018
    |
    | This file defines the extension points for vendor, we allow other
    | Addon to register functions and rule definitions with vendor.
    |
    | The structure for information is as following:
    |
    |   FunctionInformation:
    |       Name = <name>
    |       Help = <help text>
    |       Function = <function>
    |
    |   Name is the name as it will be exposed to the user, it will be prefixed
    |   by the source of your extension, so if your Source is "Bar" and you
    |   register a function "Foo" the function exposed to the rules will be
    |   Bar_Foo. The help text is required, and it explains to uses how the
    |   function works.
    |
    |   RuleDefinition:
    |       Id = <id>
    |       Name = <name>
    |       Description = <description>
    |       Script = <script>
    |       Type = "Sell" | "Keep"
    |       Order = #
    |
    |   All of these fields except for Order are required and must be
    |   non-empty strings.  Order is used for sorting the definition
    |   with the custom rule list.
    |
    |   ExtensionDefinition:
    |       Rules = { RuleDefinition1...RuleDefinitionN }
    |       Functions = { FunctionDefinition1...FunctionDefinitionN }
    |       Source = <source>
    |       Addon = <addon>
    |
    |   Rules and functions are a list of the rules and definitions which
    |   should be registered.  See the details above for each of them.
    |   Source - is the name of your Vendor extension, this can whatever
    |       you desire, but anything non-alpha numeric will be turned into
    |       underscores.
    |   Addon - This is the Addon making the call, this allows vendor
    |           to get version information and track where it came from
    |           we do verify this is valid. and for the most part
    |           you can just use the result of "select(1, ...)"
    ========================================================================--]]

local Addon, L, Config = _G[select(1,...).."_GET"]()
local Package = select(2, ...);
local AddonName = select(1, ...);

local Extensions =
{
    _exts = {},
    _functions = {},
    _rules = {},
    OnChanged = Package.CreateEvent("Extensions.OnChanged");
};

-- Simple helper for validating a string.
local function validateString(s)
    return (s and (type(s) == "string") and (string.len(s) ~= 0));
end

-- Simple helper for validating a table (non-empty)
local function validateTable(t)
    return (t and (type(t) == "table") and (table.getn(t) ~= 0));
end

-- Simple helper which validates the string is not-only valid but also
-- one of the specified arguments.
local function validateStringValue(s, ...)
    if (not validateString(s)) then
        return false;
    end

    for i,v in ipairs({...}) do
        if (s == v) then
            return true;
        end
    end

    return false;
end

-- Helper function which makes sure the provided string is valid identifier.
local function validateIdentifier(s)
    if (not validateString(s)) then
        return false;
    end
    return string.len(s) == string.len(s:match("[A-Za-z_]+[A-Za0-9_]*"));
end

local function addFunctionDefinition(ext, fdef)
    local f =
    {
        Extension = ext,
        Name = string.format("%s_%s", ext.Source, fdef.Name),
        Help = fdef.Help;
        Function = fdef.Function;
    };

    Addon:Debug("Added function '%s' from:", f.Name, ext.Name);
    table.insert(Extensions._functions, f);
end

-- Helper function which adds an entry for the extension.
local function addExtension(source, addon)
    local a =
    {
        Source = source,
        Name = addon,
        Functions = 0,
        Rules = 0;
    };

    table.insert(Extensions._exts, a);
    return a;
end

-- Helper function to traverse the extension array and find the specified
-- extension.
local function findExtension(source)
    for _,ext in ipairs(Extensions._exts) do
        if (ext.Source == source) then
            return ext;
        end
    end
end

-- Helper function to add a rule definition to the extension
local function addRuleDefinition(ext, rdef)
    local r =
    {
        Id = string.lower(string.format("E[%s.%s])", ext.Source, rdef.Id)),
        Name = rdef.Name,
        Description = rdef.Description,
        Script = rdef.Script,
        Type = rdef.Type,
        ReadOnly = true,
        Extension = ext,
        Order = tonumber(rdef.Order) or nil,
    };

    Addon:Debug("Added rule '%s' from: %s", r.Name, ext.Name);
    table.insert(Extensions._rules, r);
end

-- Function to compare two rule definitions and sort them by "order"
local function compareRules(a, b)
    if (a.Order and not b.Order) then
        return true;
    elseif (not a.Order and b.Order) then
        return false;
    elseif (not a.Order and not b.Order) then
        return (a.Name < b.Name);
    end
    return (a.Order < b.Order);
end

--[[===========================================================================
    | validateFunction:
    |   This handles the validation of a function definition, this verifies
    |   the name is a valid identifier and that help text was provided.
    ========================================================================--]]
local function validateFunction(fdef)
    if (not validateIdentifier(fdef.Name)) then
        return false, "The function definition did not contain a valid name";
    end

    if (not validateString(fdef.Help)) then
        return false, "The function definition did not contain a valid help information";
    end

    if (not fdef.Function or (type(fdef.Function) ~= "function")) then
        return false, string.format("The function definition for (%s) did not contain a valid 'Function' field", fdef.Name);
    end

    return true;
end

--[[===========================================================================
    | validateRule:
    |   This validates the specified rule definition and returns ether
    |   success, or failure and an error.
    ========================================================================--]]
local function validateRule(rdef)
    -- Id
    if (not validateString(rdef.Id)) then
        return false, "The rule definition did not contain a valid 'Id' field";
    end

    -- Name
    if (not validateString(rdef.Name)) then
        return false, string.format("The rule (%s) did not contain a valid 'Name' field", rdef.Id);
    end

    -- Description
    if (not validateString(rdef.Description)) then
        return false, string.format("The rule (%s) did not contain a valid 'Description' field", rdef.Id);
    end

    -- Script
    if (not validateString(rdef.Script)) then
        return false, string.format("The rule (%s) did not contain a valid 'Script' field", rdef.Id);
    end
    local result, message = loadstring(string.format("return(%s)", rdef.Script));
    if (not result) then
        return false, string.format("The rule (%s) has an invalid 'Script' field [%s]", rdef.Id, message);
    end

    -- Rule Type
    if (not validateStringValue(rdef.Type, Addon.c_RuleType_Sell, Addon.c_RuleType_Keep)) then
        return false, string.format("The rule (%s) has an invalid 'Type' field", rdef.Id);
    end

    -- Order if provided.
    if (rdef.Order and not tonumber(rdef.Order)) then
        return false, string.format("The rule (%s) provided a non-numeric 'Order' field", rdef.Id);
    end

    return true;
end

--[[===========================================================================
    | validateExtension:
    |   Validates the extension contains the proper information, returns
    |   either failure and a message, or success and the full name of the
    |   addon we will use to identify it.
    ========================================================================--]]
local function validateExtension(extension)
    if (not validateString(extension.Addon) and not IsAddOnLoaded(extension.Addon)) then
        return false, "The specified AddOn was either invalid or not loaded";
    end

    if (not validateIdentifier(extension.Source)) then
        return false, string.format("The extension 'Source' field was invalid. (%s)",extension.Addon);
    end

    if (string.lower(extension.Source) == string.lower(AddonName)) then
        return false, string.format("The extension 'Source' field was invalid. (%s)", extension.Addon);
    end

    local version = GetAddOnMetadata(extension.Addon, "Version");
    local _, title = GetAddOnInfo(extension.Addon);
    if (not validateString(version) or not validateString(title)) then
        return false, string.format("Unable to get information about '%s' addon", extension.Addon);
    end

    return true, string.format("%s - %s[%s]", extension.Source, title, version);
end

--[[===========================================================================
    | GetFunctions:
    |   The gets an associative array of the functions which were registered
    |   by our extensions.
    ========================================================================--]]
function Extensions:GetFunctions()
    local funcs = {};
    for _, func in ipairs(self._functions) do
        funcs[func.Name] = func.Function;
    end
    return funcs;
end

--[[===========================================================================
    | GetFunctionDocs:
    |   Retrieves the list of documentation for the functions that
    |   were registered by an addon.
    ========================================================================--]]
function Extensions:GetFunctionDocs()
    local docs = {};
    for _, func in ipairs(self._functions) do
        docs[func.Name] = func.Help;
    end
    return docs;
end

--[[===========================================================================
    | GetRules:
    |   This gets all of the rules which were registered by our extensions,
    |   optionally filtered by the specified filter.
    ========================================================================--]]
function Extensions:GetRules(filter)
    local rules = {};
    for _, rule in ipairs(self._rules) do
        if (not filter or (rule.Type == filter)) then
            table.insert(rules, rule);
        end
    end
    return rules;
end

--[[===========================================================================
    | GetRule:
    |   Searches for a particular rule registered by an extension, optinally
    |   making sure it matches the specified filter.
    ========================================================================--]]
function Extensions:GetRule(ruleId, filter)
    local id = string.lower(ruleId);
    for _, rule in ipairs(self._rules) do
        if ((rule.Id == id) and (not filter or (rule.Type == filter))) then
            return rule;
        end
    end
end

--[[===========================================================================
    | Register:
    |   This is our public API for registering
    ========================================================================--]]
function Extensions:Register(extension)
    -- Valid our argument [These will error out the load (of the extensions LUA not ours)]
    if (not extension or (type(extension) ~= "table")) then
        error("An invalid argument was provided for the extension.", 2);
    end
    local valid, name = validateExtension(extension);
    if (not valid) then
        error(name, 2);
    end

    -- Make sure we've actually got something to to.
    if (not validateTable(extension.Functions) and not validateTable(extension.Rules)) then
        error(string.format("An extension must provide rules and/or functions to be registered. (%s)", extension.Source), 2);
    end


    -- Validate all of the function definitions are valid.
    if (validateTable(extension.Functions)) then
        Addon:Debug("Validating %s function definition(s) for: %s (%s)", table.getn(extension.Functions), extension.Source, name);
        for i,fdef in ipairs(extension.Functions) do
            local valid, message = validateFunction(fdef);
            if (not valid) then
                Addon:Debug("Failed to validate function definition %d: %s (%s): %s", i, extension.Source, name, message);
                return false;
            end
        end
    end

    -- Validate all of the rules for this extension.
    if (validateTable(extension.Rules)) then
        Addon:Debug("Validating %s rule definition(s) for: %s (%s)", table.getn(extension.Rules), extension.Source, name);
        for i,rdef in ipairs(extension.Rules) do
            local valid, message = validateRule(rdef);
            if (not valid) then
                Addon:Debug("Failed to validate rule definition %d: %s (%s): %s", i, extension.Source, name, message);
                return false;
            end
        end
    end

    -- Now that we've validated everything register it into our objects.
    local ext = addExtension(extension.Source, name);
    if (extension.Functions) then
        ext.Functions = table.getn(extension.Functions);
        for _, fdef in ipairs(extension.Functions) do
            addFunctionDefinition(ext, fdef);
        end
    end
    if (extension.Rules) then
        ext.Rules = table.getn(extension.Rules);
        for _, rdef in ipairs(extension.Rules) do
            addRuleDefinition(ext, rdef);
        end
        table.sort(self._rules, compareRules);
    end

    self.OnChanged("ADDED", ext);
    Addon:Print("Completed registration of %s (%s) with %d function(s) and %d rule(s)", ext.Source, ext.Name, ext.Functions, ext.Rules);
    return true;
end

-- Expose the extensions (private to the addon) and public
-- for main registration function.
Package.Extensions = Extensions;
function Addon:RegisterExtension(extension)
    return Extensions:Register(extension);
end
