
GSEOptions = {
	["HideLoginMessage"] = false,
	["Update2415"] = true,
	["resetOOC"] = true,
	["Update2410"] = true,
	["use2"] = false,
	["STANDARDFUNCS"] = "|cff55ddcc",
	["showGSEUsers"] = false,
	["UnfoundSpellIDs"] = {
	},
	["Update2305"] = true,
	["COMMENT"] = "|cff55cc55",
	["use14"] = false,
	["Updated801"] = true,
	["CreateGlobalButtons"] = false,
	["EQUALS"] = "|cffccddee",
	["use11"] = false,
	["sendDebugOutputToChatWindow"] = false,
	["overflowPersonalMacros"] = false,
	["autoCreateMacroStubsClass"] = true,
	["debug"] = false,
	["useTranslator"] = false,
	["use6"] = false,
	["CommandColour"] = "|cFF00FF00",
	["PromptSample"] = true,
	["UNKNOWN"] = "|cffff6666",
	["UseWLMExportFormat"] = true,
	["DefaultImportAction"] = "MERGE",
	["DisabledSequences"] = {
	},
	["showGSEoocqueue"] = true,
	["DebugPrintModConditionsOnKeyPress"] = false,
	["sendDebugOutputToDebugOutput"] = false,
	["hideSoundErrors"] = false,
	["ErroneousSpellID"] = {
	},
	["AddInPacks"] = {
		["Samples"] = {
			["Name"] = "Samples",
			["Version"] = "2.4.23",
			["SequenceNames"] = {
				"Assorted Sample Macros", -- [1]
			},
		},
	},
	["STRING"] = "|cff888888",
	["clearUIErrors"] = false,
	["DefaultDisabledMacroIcon"] = "Interface\\Icons\\INV_MISC_BOOK_08",
	["Update2411"] = true,
	["TitleColour"] = "|cFFFF0000",
	["hideUIErrors"] = false,
	["initialised"] = true,
	["autoCreateMacroStubsGlobal"] = false,
	["DebugModules"] = {
		["Translator"] = false,
		["GUI"] = false,
		["Storage"] = false,
		["Versions"] = false,
		["Editor"] = false,
		["API"] = false,
		["Viewer"] = false,
		["Transmission"] = false,
	},
	["INDENT"] = "|cffccaa88",
	["MacroResetModifiers"] = {
		["Alt"] = false,
		["LeftControl"] = false,
		["LeftButton"] = false,
		["LeftAlt"] = false,
		["AnyMod"] = false,
		["RightButton"] = false,
		["Shift"] = false,
		["Button5"] = false,
		["RightShift"] = false,
		["LeftShift"] = false,
		["Control"] = false,
		["RightControl"] = false,
		["MiddleButton"] = false,
		["Button4"] = false,
		["RightAlt"] = false,
	},
	["filterList"] = {
		["All"] = false,
		["Spec"] = true,
		["Global"] = true,
		["Class"] = true,
	},
	["EmphasisColour"] = "|cFFFFFF00",
	["UseVerboseExportFormat"] = false,
	["WOWSHORTCUTS"] = "|cffddaaff",
	["RealtimeParse"] = false,
	["deleteOrphansOnLogout"] = false,
	["ActiveSequenceVersions"] = {
	},
	["UnfoundSpells"] = {
	},
	["AuthorColour"] = "|cFF00D1FF",
	["requireTarget"] = false,
	["showMiniMap"] = {
		["hide"] = true,
	},
	["NUMBER"] = "|cffffaa00",
	["use12"] = false,
	["use13"] = false,
	["NormalColour"] = "|cFFFFFFFF",
	["CONCAT"] = "|cffcc7777",
	["saveAllMacrosLocal"] = true,
	["setDefaultIconQuestionMark"] = true,
	["KEYWORD"] = "|cff88bbdd",
	["use1"] = false,
}
GSELibrary = {
	{
		["TAUNT"] = {
			["Talents"] = "CLASSIC",
			["Default"] = 1,
			["Help"] = "Uses Mocking Blow (Battle Stance) or Taunt (Defensive Stance) depending on stance.  If you are in Beserking Stance it changes to Defensive Stance.",
			["MacroVersions"] = {
				{
					"/cast [stance:1] 694; [stance:2] 355; [stance:3] 71", -- [1]
					["PostMacro"] = {
					},
					["KeyPress"] = {
					},
					["StepFunction"] = "Sequential",
					["PreMacro"] = {
					},
					["KeyRelease"] = {
					},
				}, -- [1]
			},
			["Author"] = "TimothyLuke",
			["SpecID"] = 1,
			["ManualIntervention"] = false,
		},
		["SAM_LOWLEVELWARR"] = {
			["Talents"] = "CLASSIC",
			["Default"] = 1,
			["Help"] = "A simple Warrior Starter macro.",
			["MacroVersions"] = {
				{
					"/cast [combat] 6547", -- [1]
					"/cast [combat] 8198", -- [2]
					"/cast [combat] 6192", -- [3]
					"/cast [combat] 1715", -- [4]
					"/cast [combat] 1608", -- [5]
					["PostMacro"] = {
					},
					["KeyPress"] = {
						"/startattack", -- [1]
						"/targetenemy [noharm, dead]", -- [2]
						"/cast [nocombat] 100", -- [3]
					},
					["KeyRelease"] = {
					},
					["PreMacro"] = {
					},
					["StepFunction"] = "Sequential",
				}, -- [1]
			},
			["SpecID"] = 1,
			["Author"] = "TimothyLuke",
			["ManualIntervention"] = false,
		},
	}, -- [1]
	[0] = {
	},
}
