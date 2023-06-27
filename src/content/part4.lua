---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

local function Ability_A000_Init()
  local id = "A000"

  RegisterAbilityExEvent(id, EX_EVENT_ABILITY_CHANNEL, function()
    Logger.SendInfoLocal(GetOwningPlayer(GetTriggerUnit()), "OnChannel!")
  end)

  RegisterAbilityExEvent(id, EX_EVENT_ABILITY_CAST, function()
    Logger.SendInfoLocal(GetOwningPlayer(GetTriggerUnit()), "OnCast!")
  end)

  RegisterAbilityExEvent(id, EX_EVENT_ABILITY_EFFECT, function()
    Logger.SendInfoLocal(GetOwningPlayer(GetTriggerUnit()), "OnEffect!")
  end)

  RegisterAbilityExEvent(id, EX_EVENT_ABILITY_FINISH, function()
    Logger.SendInfoLocal(GetOwningPlayer(GetTriggerUnit()), "OnFinish!")
  end)

  RegisterAbilityExEvent(id, EX_EVENT_ABILITY_CAST_END, function()
    Logger.SendInfoLocal(GetOwningPlayer(GetTriggerUnit()), "OnCastEnd!")
  end)

end


local function Item_I004_Init()
  local id = "I004"
  local abilid = fourcc("A000")

  RegisterItemExEvent(id, EX_EVENT_ITEM_PICKUP, function()
    local u = GetManipulatingUnit()
    UnitAddAbility(u, abilid)
  end)

  RegisterItemExEvent(id, EX_EVENT_ITEM_DROP, function()
    local u = GetManipulatingUnit()
    UnitRemoveAbility(u, abilid)
  end)

  RegisterItemInitCallback(id, function()
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_NORMAL, "Spell Book")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_EXTENDED, "Adds Blizzard ability while in inventory; ability has all abilityevents hooked to be in chat")

    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_NAME, "Part 4 - Ability Events")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_DESCRIPTION, "Spell Book")
  end)

end


function Part_4_Init()
  Ability_A000_Init()
  Item_I004_Init()
end

