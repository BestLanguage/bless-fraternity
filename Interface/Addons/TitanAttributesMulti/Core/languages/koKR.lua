--[[
	Do you want help us translating to your language?
	Access the translation project: http://wow.curseforge.com/addons/titan-panel-attributes-multi/localization/
	Author: Canettieri
  Korean translator: next96
--]]

local _, L = ...;
if GetLocale() == "koKR" then
-- Block
L["block"] = "막기"
L["blockt"] = "방패 막기"
-- Critical
L["critical"] = "치명타 및 극대화"
-- Dodge
L["dodge"] = "회피"
L["dodget"] = "회피율"
-- Haste
L["haste"] = "가속"
-- Item Level
L["ilvl"] = "아이템 레벨"
L["overall"] = "전체: "
L["equipped"] = "착용: "
-- Mana Regeneration
L["manareg"] = "마나 회복량"
L["manaregtooltip"] = "초당 마나 회복량|r\r [ 시전중이 아닐 때 | 시전중일 때|r].\r"
-- Mastery
L["mastery"] = "특화"
-- Melee Power
L["meleepower"] = "근접 전투력"
-- Multistrike
L["multistrike"] = "연속 타격"
-- Parry
L["parry"] = "막기"
L["parryt"] = "무기 막기"
-- Ranged Power
L["rangedpower"] = "원거리"
-- Spell Power
L["spellpower"] = "주문력"
-- Versatility
L["versatility"] = "유연성"
L["versatilitytooltip"] = "유연성|r.\r [+공격력, 치유량 | - 받는 피해|r].\r"
--- Shared
L["tooltipDescriptionPer"] = "능력치 (백분율): |cFFB4EEB4"
L["tooltipDescriptionCha"] = "능력치 백분율 표시: |cFFB4EEB4"
L["tooltipDescriptionExa"] = "정확한 값 표시: |cFFB4EEB4"
L["session"] = "손익 계산: "
L["moreinfo"] = "|cFFB4EEB4도움말:|r |cFFFFFFFF마우스 클릭으로 의 캐릭터 창을 엽니다. " -- In this case, player name is always the last word. I change it and I think it's wrong now. (sorry)
L["showbb"] = "바에 수입과 지출을 표시합니다."
end
