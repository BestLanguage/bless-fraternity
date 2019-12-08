--[[--
	alex@0
--]]--
----------------------------------------------------------------------------------------------------
local ADDON, NS = ...;
local FUNC = NS.FUNC;
if not FUNC then return;end
local L = NS.L;
if not L then return;end
local STR = L.MISC;
----------------------------------------------------------------------------------------------------
local math, table, string, pairs, type, select, tonumber, unpack = math, table, string, pairs, type, select, tonumber, unpack;
local _G = _G;
local GameTooltip = GameTooltip;
----------------------------------------------------------------------------------------------------
local LCONFIG = L.CONFIG;
if not LCONFIG then
	return;
end
local CB_DATA = L.CHATBAR;
if not CB_DATA then return;end
----------------------------------------------------------------------------------------------------
local alaBaseBtn = __alaBaseBtn;
if not alaBaseBtn then
	return;
end
----------------------------------------------------------------------------------------------------chat filter
local control_chat_filter_reverse = false;
local control_chat_rep_interval = nil;
local control_chat_repeated = false;
local control_chat_repeated_deep = false;
local control_chat_repeated_info = false;
local chatFilter_btn = nil;
local chatFilter_btnPackIndex = 3;
local chatFilter_editBox = nil;
local filterWord = {  };


-- [msg] = { time, lineId, filtered, actually_displayed_msg, }
local caches = {  };
local function cache_updater()
	if control_chat_rep_interval then
		local t = time() - control_chat_rep_interval;
		for k, v in pairs(caches) do
			if v[3] ~= true and v[1] <= t then
				caches[k] = nil;
			end
		end
	end
end
C_Timer.NewTicker(1.0, cache_updater);
local function process_repeat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...)
	while true do
		if strlen(arg1) > 48 then
			local msg = gsub(arg1, "^[ ]+", "");
			local pos = nil;
			for i = 18, 24 do
				local c = strbyte(strsub(msg, i, i));
				if c < 0x80 then
					pos = i;
					break;
				elseif c > 0xc0 then	-- 110x xxxx
					pos = i - 1;
					break;
				end
			end
			if pos then
				local pattern = gsub(strsub(msg, 1, pos), "[%%%.%+%-%*%?%[%]%(%)]", "%%%1");
				local temp = strfind(msg, pattern, pos);
				local temp2 = -1;
				if temp then
					pattern = gsub(gsub(strsub(msg, 1, temp - 1), "[ ]+$", ""), "^[ ]+", "");
					local pattern2 = gsub(pattern, "[%%%.%+%-%*%?%[%]%(%)]","%%%1");
					temp, temp2 = gsub(msg, pattern2, "");
					if temp2 > 1 then
						temp = gsub(gsub(temp, "^[ ]+", ""), "[ ]+$", "");
						temp2 = gsub(temp, "[%%%.%+%-%*%?%[%]%(%)]", "%%%1");
						if strfind(pattern, temp2) then
							temp = "";
						end
						msg = pattern .. temp;
						if control_chat_repeated_info then
							temp = "\124cffff00ff\124Halacfilter:" .. arg11 .. "\124h[R]\124h\124r" .. msg;
						else
							temp = msg;
						end
						if control_chat_rep_interval then
							if caches[msg] then
								caches[arg1][3] = 1;
								return true, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
							end
							caches[msg] = { time(), -1, filtered, };
							caches[arg1][4] = temp;
						end
						arg1 = temp;
					else
						break;
					end
				else
					break;
				end
			else
				break;
			end
		else
			break;
		end
		if not control_chat_repeated_deep then
			break;
		end
	end
	return false, arg1;
end
local function chat_filter_Filter(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...)
	local cache = caches[arg1];
	if cache then
		if cache[2] == arg11 then
			return cache[3], cache[4] or arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
		else
			-- print("|cffff0000REP FILTERED|r", arg1);
			if control_chat_rep_interval then
				return true, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
			else
				return cache[3], cache[4] or arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
			end
		end
	end
	local filtered = control_chat_filter_reverse;
	if #filterWord == 0 then
		filtered = false;
	else
		for i = 1, #filterWord do
			if strfind(arg1, filterWord[i]) then
				filtered = not control_chat_filter_reverse;
				-- print("|cffff0000FILTERED|r", filterWord[i], arg1);
				break;
			end
		end
	end
	if control_chat_rep_interval or filtered then
		caches[arg1] = { time(), arg11, filtered, };
	end
	if control_chat_repeated and not filtered then
		local temp = nil;
		temp, arg1 = process_repeat(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...);
		if temp then
			return true, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
		end
	end
	return filtered, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
end
local function CHATFILTER_ONCLICK(button, mouse)
	if not chatFilter_editBox then
		chatFilter_editBox = CreateFrame("EditBox", nil, UIParent);
		button:HookScript("OnHide", function() chatFilter_editBox:Hide(); end)
		chatFilter_editBox:SetWidth(min(320, GetScreenWidth()));
		chatFilter_editBox:SetFontObject(GameFontHighlightSmall);
		chatFilter_editBox:SetAutoFocus(false);
		chatFilter_editBox:SetJustifyH("LEFT");
		chatFilter_editBox:Hide();
		chatFilter_editBox:SetMultiLine(true);
		chatFilter_editBox:EnableMouse(true);
		--chatFilter_editBox:SetScript("OnEnterPressed", function(self)
			--self:SetText(self:GetText().."\n");
		--end);
		chatFilter_editBox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus();
			--self:SetText(alaChatConfig and alaChatConfig["chat_filter_word"] or "");
			self:Hide();
		end);
		chatFilter_editBox:SetPoint("TOPLEFT", button, "BOTTOMRIGHT", 4, 4);
		chatFilter_editBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8";	-- "Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
			tile = true, 
			tileSize = 2, 
			edgeSize = 2, 
			insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
		chatFilter_editBox:SetBackdropColor(0.05, 0.05, 0.05, 1.0);
		chatFilter_editBox:SetFrameStrata("FULLSCREEN_DIALOG");
		chatFilter_editBox:SetClampedToScreen(true);

		-- f:SetPoint("TOPLEFT", chatFilter_editBox, "TOPLEFT", - 4, 28);
		-- f:SetPoint("BOTTOMRIGHT", chatFilter_editBox, "BOTTOMRIGHT", 4, - 28);
		-- f:Hide();
		-- f:SetFrameStrata("FULLSCREEN_DIALOG");

		local eOK = CreateFrame("Button", nil, chatFilter_editBox);
		eOK:SetSize(20, 20);
		eOK:SetNormalTexture("Interface\\Buttons\\ui-checkbox-check");
		eOK:SetPushedTexture("Interface\\Buttons\\ui-checkbox-check");
		eOK:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");
		eOK:SetPoint("BOTTOMLEFT", chatFilter_editBox, "TOPLEFT", 4, 0);
		eOK:SetScript("OnClick", function(self)
			chatFilter_editBox:Hide();
			alaChatConfig["chat_filter_word"] = chatFilter_editBox:GetText();
			FUNC.SETVALUE["chat_filter_word"](chatFilter_editBox:GetText());
		end);
		chatFilter_editBox.OK = eOK;

		local eClose = CreateFrame("Button", nil, chatFilter_editBox);
		eClose:SetSize(20, 20);
		eClose:SetNormalTexture("Interface\\Buttons\\UI-StopButton");
		eClose:SetPushedTexture("Interface\\Buttons\\UI-StopButton");
		eClose:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight");
		eClose:SetPoint("LEFT", eOK, "RIGHT", 4, 0);
		eClose:SetScript("OnClick", function(self) chatFilter_editBox:Hide(); end);
		chatFilter_editBox.close = eClose;

		button:HookScript("OnHide", function() chatFilter_editBox:Hide(); end);
	end
	if mouse == "LeftButton" then
		if chatFilter_editBox:IsShown() then
			chatFilter_editBox:Hide();
		else
			chatFilter_editBox:Show();
			chatFilter_editBox:SetText(alaChatConfig["chat_filter_word"] and alaChatConfig["chat_filter_word"] or "");
		end
	else
		-- alaChatConfig["keyWord"] = "";
		-- keyWordHighlight_SetVal("");
		-- chatFilter_editBox:Hide();
	end
end
local function chat_filter_On()
	ala_add_message_event_filter("CHAT_MSG_CHANNEL", "chat_filter", chat_filter_Filter)
	ala_add_message_event_filter("CHAT_MSG_SAY", "chat_filter", chat_filter_Filter)
	ala_add_message_event_filter("CHAT_MSG_YELL", "chat_filter", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", chat_filter_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", chat_filter_Filter)
	if chatFilter_btn then
		alaBaseBtn:AddBtn(chatFilter_btnPackIndex,-1,chatFilter_btn,true,false,true);
	else
		chatFilter_btn=alaBaseBtn:CreateBtn(
				chatFilter_btnPackIndex,
				-1,
				"chatFilter_btn",
				"char",
				"F",
				nil,
				function(self,button)
					CHATFILTER_ONCLICK(self, button);
				end,
				{
					CB_DATA.CHATFILTER_0,
					"",
					CB_DATA.CHATFILTER_1,
					CB_DATA.CHATFILTER_2,
					CB_DATA.CHATFILTER_3,
				}
		);
	end
end
local function chat_filter_Off()
	ala_remove_message_event_filter("CHAT_MSG_CHANNEL", "chat_filter")
	ala_remove_message_event_filter("CHAT_MSG_SAY", "chat_filter")
	ala_remove_message_event_filter("CHAT_MSG_YELL", "chat_filter")
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BN_WHISPER", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY_LEADER", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_OFFICER", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_AFK", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_EMOTE", chat_filter_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_DND", chat_filter_Filter)
	alaBaseBtn:RemoveBtn(chatFilter_btn,true);
end

local function chat_filter_Init()
end

local function chat_filter_word_SetVal(val)
	if chatFilter_editBox and chatFilter_editBox:IsShown() then
		chatFilter_editBox:SetText(val);
	end
	val = gsub(val, "[%%%.%+%-%*%?%[%]%(%)]","%%%1").. "\n\n";
	wipe(filterWord);
	for v in gmatch(val,"%s*([^\n]+)\n") do
		tinsert(filterWord, v);
		local v1 = strupper(v);
		local v2 = strlower(v);
		if v1 ~= v then
			tinsert(filterWord,v1);
		end
		if v2 ~= v then
			tinsert(filterWord,v2);
		end
	end
end
FUNC.ON.chat_filter = chat_filter_On;
FUNC.OFF.chat_filter = chat_filter_Off;

FUNC.SETVALUE.chat_filter_word = chat_filter_word_SetVal;

FUNC.ON.chat_filter_repeated_words = function()
	control_chat_repeated = true;
	control_chat_repeated_deep = true;
end;
FUNC.OFF.chat_filter_repeated_words = function()
	control_chat_repeated = false;
	control_chat_repeated_deep = false;
end;
FUNC.ON.chat_filter_repeated_words_info = function()
	control_chat_repeated_info = true;
end;
FUNC.OFF.chat_filter_repeated_words_info = function()
	control_chat_repeated_info = false;
end;

-- FUNC.ON.chat_filter_reverse = function() control_chat_filter_reverse = true; end;
-- FUNC.OFF.chat_filter_reverse = function() control_chat_filter_reverse = false; end;
FUNC.SETVALUE.chat_filter_rep_interval = function(interval)
	if interval > 0 then
		control_chat_rep_interval = interval;
	else
		control_chat_rep_interval = nil;
		for k, v in pairs(caches) do
			if not v[3] then
				caches[k] = nil;
			end
		end
	end
end

----------------
local _SetHyperlink = ItemRefTooltip.SetHyperlink;
ItemRefTooltip.SetHyperlink = function(frame, ref, ...)
	local _, _, lineId = strfind(ref, "alacfilter:(%d+)");
	lineId = tonumber(lineId);
	-- print(ref, link, lineId)
	if lineId then
		for msg, v in pairs(caches) do
			if v[2] == lineId then
				if not ItemRefTooltip:IsShown() then
					ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE");
				end
				ItemRefTooltip:SetText(STR.chat_filter_repeated_words_info_details);
				ItemRefTooltip:AddLine(STR.chat_filter_repeated_words_info_orig);
				ItemRefTooltip:AddLine(msg);
				if v[4] then
					ItemRefTooltip:AddLine(STR.chat_filter_repeated_words_info_disp);
					ItemRefTooltip:AddLine(v[4]);
				end
				ItemRefTooltip:Show();
				break;
			end
		end
		return true;
	else
		return _SetHyperlink(frame, ref, ...)
	end
end

----------------------------------------------------------------------------------------------------highlight
local control_keyWordHighlight = false;
local control_keyWordHighlight_Exc = false;
local keyWordHighlight_btn = nil;
local keyWordHighlight_btnPackIndex = 3;
local keyWordHighlight_editBox = nil;
local highlight_color = "00ff00";
local keyWord = {};
local repKeyWord = {};

local function updateRepKeyWord()
	repKeyWord = {};
	for i = 1,#keyWord do
		repKeyWord[i] = "\124cff" .. highlight_color .. keyWord[i] .. "\124r";
	end
end

local function keyWordHighlight_SetColor(r, g, b)
	highlight_color = format("%.2x%.2x%.2x", r * 255, g * 255, b* 255);
	updateRepKeyWord();
end
local function keyWordHighlight_SetVal(val)
	if keyWordHighlight_editBox and keyWordHighlight_editBox:IsShown() then
		keyWordHighlight_editBox:SetText(val);
	end
	val = gsub(val, "[%%%.%+%-%*%?%[%]%(%)]","%%%1").. "\n\n";
	wipe(keyWord);
	for v in gmatch(val,"%s*([^\n]+)\n") do
		tinsert(keyWord,v);
		local v1 = strupper(v);
		local v2 = strlower(v);
		if v1 ~= v then
			tinsert(keyWord,v1);
		end
		if v2 ~= v then
			tinsert(keyWord,v2);
		end
	end
	updateRepKeyWord();
end

local function KEYWORDHEIGHLIGHT_ONCLICK(button, mouse)
	if not keyWordHighlight_editBox then
		keyWordHighlight_editBox = CreateFrame("EditBox", nil, UIParent);
		button:HookScript("OnHide", function() keyWordHighlight_editBox:Hide(); end)
		keyWordHighlight_editBox:SetWidth(min(320, GetScreenWidth()));
		keyWordHighlight_editBox:SetFontObject(GameFontHighlightSmall);
		keyWordHighlight_editBox:SetAutoFocus(false);
		keyWordHighlight_editBox:SetJustifyH("LEFT");
		keyWordHighlight_editBox:Hide();
		keyWordHighlight_editBox:SetMultiLine(true);
		keyWordHighlight_editBox:EnableMouse(true);
		--keyWordHighlight_editBox:SetScript("OnEnterPressed", function(self)
			--self:SetText(self:GetText().."\n");
		--end);
		keyWordHighlight_editBox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus();
			--self:SetText(alaChatConfig and alaChatConfig["keyWord"] or "");
			self:Hide();
		end);
		keyWordHighlight_editBox:SetPoint("TOPLEFT", button, "BOTTOMRIGHT", 4, 4);
		keyWordHighlight_editBox:SetBackdrop({
			bgFile = "Interface\\Buttons\\WHITE8X8";	-- "Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
			tile = true, 
			tileSize = 2, 
			edgeSize = 2, 
			insets = { left = 2, right = 2, top = 2, bottom = 2 }
		});
		keyWordHighlight_editBox:SetBackdropColor(0.05, 0.05, 0.05, 1.0);
		keyWordHighlight_editBox:SetFrameStrata("FULLSCREEN_DIALOG");
		keyWordHighlight_editBox:SetClampedToScreen(true);

		-- f:SetPoint("TOPLEFT", keyWordHighlight_editBox, "TOPLEFT", - 4, 28);
		-- f:SetPoint("BOTTOMRIGHT", keyWordHighlight_editBox, "BOTTOMRIGHT", 4, - 28);
		-- f:Hide();
		-- f:SetFrameStrata("FULLSCREEN_DIALOG");

		local eOK = CreateFrame("Button", nil, keyWordHighlight_editBox);
		eOK:SetSize(20, 20);
		eOK:SetNormalTexture("Interface\\Buttons\\ui-checkbox-check");
		eOK:SetPushedTexture("Interface\\Buttons\\ui-checkbox-check");
		eOK:SetHighlightTexture("Interface\\Buttons\\ui-panel-minimizebutton-highlight");
		eOK:SetPoint("BOTTOMLEFT", keyWordHighlight_editBox, "TOPLEFT", 4, 0);
		eOK:SetScript("OnClick", function(self)
			keyWordHighlight_editBox:Hide();
			alaChatConfig["keyWord"] = keyWordHighlight_editBox:GetText();
			FUNC.SETVALUE["keyWord"](keyWordHighlight_editBox:GetText());
		end);
		keyWordHighlight_editBox.OK = eOK;

		local eClose = CreateFrame("Button", nil, keyWordHighlight_editBox);
		eClose:SetSize(20, 20);
		eClose:SetNormalTexture("Interface\\Buttons\\UI-StopButton");
		eClose:SetPushedTexture("Interface\\Buttons\\UI-StopButton");
		eClose:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight");
		eClose:SetPoint("LEFT", eOK, "RIGHT", 4, 0);
		eClose:SetScript("OnClick", function(self) keyWordHighlight_editBox:Hide(); end);
		keyWordHighlight_editBox.close = eClose;

		button:HookScript("OnHide", function() keyWordHighlight_editBox:Hide(); end);
	end
	if mouse == "LeftButton" then
		if keyWordHighlight_editBox:IsShown() then
			keyWordHighlight_editBox:Hide();
		else
			keyWordHighlight_editBox:Show();
			keyWordHighlight_editBox:SetText(alaChatConfig["keyWord"] and alaChatConfig["keyWord"] or "");
		end
	else
		-- alaChatConfig["keyWord"] = "";
		-- keyWordHighlight_SetVal("");
		-- keyWordHighlight_editBox:Hide();
		alaChatConfig["keyWordHighlight_Exc"] = not alaChatConfig["keyWordHighlight_Exc"];
		if alaChatConfig["keyWordHighlight_Exc"] then
			FUNC.ON.keyWordHighlight_Exc();
			if GetMouseFocus() == keyWordHighlight_btn then
				keyWordHighlight_btn:GetScript("OnEnter")(keyWordHighlight_btn);
			end
		else
			FUNC.OFF.keyWordHighlight_Exc();
			if GetMouseFocus() == keyWordHighlight_btn then
				keyWordHighlight_btn:GetScript("OnEnter")(keyWordHighlight_btn);
			end
		end
	end
end

local function keyWordHighlight_Filter(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...)
	if #keyWord == 0 then
		return false, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
	end
	local found = false;
	for i = 1, #keyWord do
		if strfind(arg1, keyWord[i]) then
			arg1 = gsub(arg1, keyWord[i], repKeyWord[i]);
			found = true;
		end
	end
	return control_keyWordHighlight_Exc and not found, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, ...;
end

local function keyWordHighlight_On()
	ala_add_message_event_filter("CHAT_MSG_CHANNEL", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_CHANNEL_JOIN", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_CHANNEL_LEAVE", "keyWordHighlight", keyWordHighlight_Filter)
	ala_add_message_event_filter("CHAT_MSG_SAY", "keyWordHighlight", keyWordHighlight_Filter)
	ala_add_message_event_filter("CHAT_MSG_YELL", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_WHISPER", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_BN_WHISPER", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_WHISPER_INFORM", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_RAID", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_RAID_LEADER", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_RAID_WARNING", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_PARTY", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_PARTY_LEADER", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_INSTANCE_CHAT", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_INSTANCE_CHAT_LEADER", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_GUILD", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_OFFICER", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_AFK", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_EMOTE", "keyWordHighlight", keyWordHighlight_Filter)
	-- ala_add_message_event_filter("CHAT_MSG_DND", "keyWordHighlight", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", keyWordHighlight_Filter)
	-- ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", keyWordHighlight_Filter)

	if keyWordHighlight_btn then
		alaBaseBtn:AddBtn(keyWordHighlight_btnPackIndex,-1,keyWordHighlight_btn,true,false,true);
	else
		keyWordHighlight_btn=alaBaseBtn:CreateBtn(
				keyWordHighlight_btnPackIndex,
				-1,
				"keyWordHighlight_btn",
				"char",
				"K",
				nil,
				function(self,button)
					KEYWORDHEIGHLIGHT_ONCLICK(self, button);
				end,
				{
					CB_DATA.KEYWORDHEIGHLIGHT_0,
					"",
					CB_DATA.KEYWORDHEIGHLIGHT_1,
					CB_DATA.KEYWORDHEIGHLIGHT_2,
					CB_DATA.KEYWORDHEIGHLIGHT_3,
				}
		);
		local glow = keyWordHighlight_btn:CreateTexture(nil, "OVERLAY");
		glow:SetTexture("interface\\characterframe\\disconnect-icon");
		glow:SetTexCoord(50 / 64, 14 / 64, 12 / 64, 48 / 64);
		-- glow:SetBlendMode("ADD");
		glow:SetPoint("TOPLEFT", keyWordHighlight_btn, "TOPLEFT");
		glow:SetPoint("BOTTOMRIGHT", keyWordHighlight_btn, "BOTTOMRIGHT");
		keyWordHighlight_btn.glow = glow;
		if control_keyWordHighlight_Exc then
			FUNC.ON.keyWordHighlight_Exc();
		else
			FUNC.OFF.keyWordHighlight_Exc();
		end
	end
end
local function keyWordHighlight_Off()
	ala_remove_message_event_filter("CHAT_MSG_CHANNEL", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_CHANNEL_JOIN", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_CHANNEL_LEAVE", "keyWordHighlight")
	ala_remove_message_event_filter("CHAT_MSG_SAY", "keyWordHighlight")
	ala_remove_message_event_filter("CHAT_MSG_YELL", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_WHISPER", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_BN_WHISPER", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_WHISPER_INFORM", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_RAID", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_RAID_LEADER", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_RAID_WARNING", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_PARTY", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_PARTY_LEADER", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_INSTANCE_CHAT", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_INSTANCE_CHAT_LEADER", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_GUILD", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_OFFICER", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_AFK", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_EMOTE", "keyWordHighlight")
	-- ala_remove_message_event_filter("CHAT_MSG_DND", "keyWordHighlight")
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BN_WHISPER", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_LEADER", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID_WARNING", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY_LEADER", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_OFFICER", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_AFK", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_EMOTE", keyWordHighlight_Filter)
	-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_DND", keyWordHighlight_Filter)
	alaBaseBtn:RemoveBtn(keyWordHighlight_btn,true);
end

local function keyWordHighlight_Init()
end

FUNC.ON.keyWordHighlight = keyWordHighlight_On;
FUNC.OFF.keyWordHighlight = keyWordHighlight_Off;

FUNC.SETVALUE.keyWord = keyWordHighlight_SetVal;
FUNC.SETVALUE.keyWordColor = keyWordHighlight_SetColor;

FUNC.ON.keyWordHighlight_Exc = function()
	control_keyWordHighlight_Exc = true;
	if keyWordHighlight_btn then
		keyWordHighlight_btn.glow:Show()
		-- keyWordHighlight_btn.glow:SetVertexColor(1, 0, 0);
		keyWordHighlight_btn.gtLine[6] = CB_DATA.KEYWORDHEIGHLIGHT_B;
	end
end;
FUNC.OFF.keyWordHighlight_Exc = function()
	control_keyWordHighlight_Exc = false;
	if keyWordHighlight_btn then
		keyWordHighlight_btn.glow:Hide()
		-- keyWordHighlight_btn.glow:SetVertexColor(0, 1, 0);
		keyWordHighlight_btn.gtLine[6] = CB_DATA.KEYWORDHEIGHLIGHT_A;
	end
end;
