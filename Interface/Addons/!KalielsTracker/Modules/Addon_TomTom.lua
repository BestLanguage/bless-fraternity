--- Kaliel's Tracker
--- Copyright (c) 2012-2019, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_AddonTomTom")
KT.AddonTomTom = M

local ACD = LibStub("MSA-AceConfigDialog-3.0")
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local questWaypoints = {}
local superTrackedQuestID = 0
local questChanged = false

local eventFrame

--------------
-- Internal --
--------------



--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	db = KT.db.profile
	self.isLoaded = (KT:CheckAddOn("TomTom", "") and db.addonTomTom)

	local defaults = KT:MergeTables({
		profile = {
			tomtomArrival = 20,
			tomtomAnnounce = true,
		}
	}, KT.db.defaults)
	KT.db:RegisterDefaults(defaults)
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
end