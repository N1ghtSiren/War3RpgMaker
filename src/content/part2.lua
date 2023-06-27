---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

local function Item_I00S_Init()
  local id = "I00S"

  local desc = "Actual stats are added to description using different script, which may be not used at your will."
  .. "\nStats are added by parsing all existing item stats (at the moment of calling), and added to existing stat description."
  .. "\nCheck 'item_description.lua' and 'stat_definitions.lua' for realisation"

  RegisterItemInitCallback(id, function()
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_EXTENDED, desc)
  end)

end


local function Item_I00G_Init()
  local id = "I00G"

  RegisterItemStats_AP(id, 100, 100, 100, 100, 100, 100, 40)
  RegisterItemStats_BP(id, 100, 100, 100)

  RegisterItemInitCallback(id, function()
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_NORMAL, "Item with Stats")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_EXTENDED, "contains some advanced stats")

    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_NAME, "Part 2 - Advanced Stats")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_DESCRIPTION, "Item with Stats")
  end)

end


local function Item_I001_Init()
  local id = "I001"

  RegisterItemStats_A(id, 15, 5, 35, 20, 10, 5, 40)
  RegisterItemStats_B(id, 15, 10, 10)
  RegisterItemStats_C(id, 100)

  RegisterItemInitCallback(id, function()
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_NORMAL, "Item with Stats")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_TOOLTIP_EXTENDED, "Adds some stats to heroes,\nonly affects \nIsUnitType(u, UNIT_TYPE_HERO)==true")

    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_NAME, "Part 2 - Basic Stats")
    SetBaseItemStringFieldById(fourcc(id), ITEM_SF_DESCRIPTION, "Item with Stats")
  end)
end


function Part_2_Init()
  Item_I00S_Init()
  Item_I001_Init()
  Item_I00G_Init()
end