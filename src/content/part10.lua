---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

local function Item_I00J_Init()
  local id = "I00J"

  RegisterItemStats_C(id, 200)
end

local function Item_I00I_Init()
  local id = "I00I"

  RegisterItemStats_D(id, 0,100)
end

local function Item_I00H_Init()
  local id = "I00H"

  RegisterItemStats_D(id, 20,0)
end

local function Item_I00K_Init()
  local id = "I00K"

  RegisterItemExEvent(id, EX_EVENT_ITEM_DROP, function()
    local u = GetManipulatingUnit()

    RegisterUnitUseDPS(u, false)
    --force update stat
    ModifyUnitStat(u, STAT_KEY_DPS, 0)
    -- or
    -- UpdateUnitStatsForced(u)
  end)

  RegisterItemExEvent(id, EX_EVENT_ITEM_PICKUP, function()
    local u = GetManipulatingUnit()

    RegisterUnitUseDPS(u, true)
    -- force update stat
    ModifyUnitStat(u, STAT_KEY_DPS, 0)
    -- or
    -- UpdateUnitStatsForced(u)
  end)

  RegisterItemInitCallback(id, function()
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_EXTENDED, "Enables DPS usage for this unit as long as item in inventory")
  end)

end

local function InitDummy()
  local id = "e000"

  CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), id, 2300, 1960, 270)
end

function Part_10_Init()
  InitDummy()
  Item_I00K_Init()
  Item_I00H_Init()
  Item_I00I_Init()
  Item_I00J_Init()
end

