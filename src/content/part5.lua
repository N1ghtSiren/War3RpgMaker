---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

local function I005_OnDeath()
  --event args can be grabbed from assigned playerunitevent

  Logger.SendInfoLocal(GetOwningPlayer(GetDyingUnit()), "cheese holder is died!")
end

local function I005_OnSpellEffect()
  Logger.SendInfoLocal(GetOwningPlayer(GetTriggerUnit()), "cheese holder is casting ability!")
end

local function I005_OnAttack()
  Logger.SendInfoLocal(GetOwningPlayer(GetEventDamageSource()), "cheese holder is attacking!")
end

local function I005_OnDamaging()
  Logger.SendInfoLocal(GetOwningPlayer(GetEventDamageSource()), "cheese holder is damaging!")
end

local function I005_OnDamaged()
  Logger.SendInfoLocal(GetOwningPlayer(GetEventDamageTarget()), "cheese holder is damaged!")
end


local function Item_I005_Init()
  local id = "I005"

  RegisterItemInitCallback(id, function()
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_NORMAL, "Cheese")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_EXTENDED, "Adds unit events to unit while in inventory: OnDeath, OnSpellEffect, OnAttack, OnDamaging, OnDamaged")

    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_NAME, "Part 5 - Unit Events")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_DESCRIPTION, "Cheese")
  end)

  RegisterCallbackOnUnitEventOnItem(id, EX_EVENT_UNIT_DEATH, I005_OnDeath)
  RegisterCallbackOnUnitEventOnItem(id, EX_EVENT_UNIT_SPELL_EFFECT, I005_OnSpellEffect)
  RegisterCallbackOnUnitEventOnItem(id, EX_EVENT_UNIT_ATTACKING, I005_OnAttack)
  RegisterCallbackOnUnitEventOnItem(id, EX_EVENT_UNIT_DAMAGING, I005_OnDamaging)
  RegisterCallbackOnUnitEventOnItem(id, EX_EVENT_UNIT_DAMAGED, I005_OnDamaged)
end


local function Unit_e000_Init()
  local id = "e000"

  RegisterUnitTypeRespawnTime(id, 5)

  RegisterDefaultUnitStats_A(id, 10, 5, 1000, 10, 20, 0.1, 10)
  RegisterDefaultUnitStats_B(id, 0, 0, 0)
  RegisterDefaultUnitStats_C(id, 2)
end


function Part_5_Init()
  Unit_e000_Init()
  Item_I005_Init()
end

