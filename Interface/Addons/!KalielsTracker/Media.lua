--- Kaliel's Tracker
--- Copyright (c) 2012-2019, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...

local LSM = LibStub("LibSharedMedia-3.0")

local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local soundPath = "Sound\\Character\\"

local media = {
    -- Textures
    { type = "BORDER",      name = "Border",        filePath = mediaPath.."KT-border" },
    { type = "STATUSBAR",   name = "Flat",          filePath = mediaPath.."KT-statusbar-flat" },
    -- Sounds (Blizzard)
    { type = "SOUND",       name = "Default",       filePath = "Sound\\Creature\\Peon\\PeonBuildingComplete1.ogg" },
    { type = "SOUND",       name = "Dwarf (M)",     filePath = soundPath.."Dwarf\\DwarfVocalMale\\DwarfMaleCongratulations04.ogg" },
    { type = "SOUND",       name = "Dwarf (F)",     filePath = soundPath.."Dwarf\\DwarfVocalFemale\\DwarfFemaleCongratulations01.ogg" },
    { type = "SOUND",       name = "Gnome (M)",     filePath = soundPath.."Gnome\\GnomeVocalMale\\GnomeMaleCongratulations03.ogg" },
    { type = "SOUND",       name = "Gnome (F)",     filePath = soundPath.."Gnome\\GnomeVocalFemale\\GnomeFemaleCongratulations01.ogg" },
    { type = "SOUND",       name = "Human (M)",     filePath = soundPath.."Human\\HumanVocalMale\\HumanMaleCongratulations01.ogg" },
    { type = "SOUND",       name = "Human (F)",     filePath = soundPath.."Human\\HumanVocalFemale\\HumanFemaleCongratulations01.ogg" },
    { type = "SOUND",       name = "NightElf (M)",  filePath = soundPath.."NightElf\\NightElfVocalMale\\NightElfMaleCongratulations01.ogg" },
    { type = "SOUND",       name = "NightElf (F)",  filePath = soundPath.."NightElf\\NightElfVocalFemale\\NightElfFemaleCongratulations02.ogg" },
    { type = "SOUND",       name = "Orc (M)",       filePath = soundPath.."Orc\\OrcVocalMale\\OrcMaleCongratulations02.ogg" },
    { type = "SOUND",       name = "Orc (F)",       filePath = soundPath.."Orc\\OrcVocalFemale\\OrcFemaleCongratulations01.ogg" },
    { type = "SOUND",       name = "Tauren (M)",    filePath = "Sound\\Creature\\Tauren\\TaurenYes3.ogg" },
    { type = "SOUND",       name = "Tauren (F)",    filePath = soundPath.."Tauren\\TaurenVocalFemale\\TaurenFemaleCongratulations01.ogg" },
    { type = "SOUND",       name = "Troll (M)",     filePath = soundPath.."Troll\\TrollVocalMale\\TrollMaleCongratulations01.ogg" },
    { type = "SOUND",       name = "Troll (F)",     filePath = soundPath.."Troll\\TrollVocalFemale\\TrollFemaleCongratulations01.ogg" },
    { type = "SOUND",       name = "Undead (M)",    filePath = soundPath.."Scourge\\ScourgeVocalMale\\UndeadMaleCongratulations02.ogg" },
    { type = "SOUND",       name = "Undead (F)",    filePath = soundPath.."Scourge\\ScourgeVocalFemale\\UndeadFemaleCongratulations01.ogg" },
}

for _, item in ipairs(media) do
    LSM:Register(LSM.MediaType[item.type], "KT - "..item.name, item.filePath)
end