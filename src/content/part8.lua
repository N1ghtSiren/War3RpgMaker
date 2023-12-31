---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

local function Ability_A001_Init()
  local id = "A001"

  RegisterAbilityExEvent(id, EX_EVENT_ABILITY_EFFECT, function()
    ShowItemCrafts(GetOwningPlayer(GetTriggerUnit()), GetSpellTargetItem())
  end)

end


local function Ability_A003_Init()
  local id = "A003"

  RegisterAbilityExEvent(id, EX_EVENT_ABILITY_EFFECT, function()
    ShowAllCrafts(GetOwningPlayer(GetTriggerUnit()))
  end)
end


local function Item_I00E_Init()
  local id = "I00E"

  RegisterItemExEvent(id, EX_EVENT_ITEM_PICKUP, function()
    local u = GetManipulatingUnit()

    UnitAddAbility(u, fourcc("A001"))
    UnitAddAbility(u, fourcc("A003"))
  end)

  RegisterItemExEvent(id, EX_EVENT_ITEM_DROP, function()
    local u = GetManipulatingUnit()

    UnitRemoveAbility(u, fourcc("A001"))
    UnitRemoveAbility(u, fourcc("A003"))
  end)

end


function Part_8_Init()
  Ability_A001_Init()
  Ability_A003_Init()
  Item_I00E_Init()

end

