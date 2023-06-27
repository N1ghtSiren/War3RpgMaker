---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

local function Crafting_Init()
  local id = "I009"

  RegisterItemExEvent(id, EX_EVENT_ITEM_PICKUP, function()
    local rune = GetManipulatedItem()
    local u = GetManipulatingUnit()

    ShowCraftingDialog(u)

    TimerStartSingle(0, function()
      RemoveItem(rune)        -- рунка утекает, почему - непонятно
    end)
  end)
end


local function I006_Init()
  local id_k3 = "I006"
  local id_k2 = "I007"
  local id_k1 = "I008"

  RegisterCraftRecipe(id_k2, id_k1, id_k1)
  RegisterCraftRecipe(id_k3, id_k2, id_k2)

  RegisterItemExEvent(id_k3, EX_EVENT_ITEM_DROP, function()
    local i = GetManipulatedItem()

    for j = 0, 3 do
      CreateItem(fourcc(id_k1), 110, 1950-j*64)
    end

    TimerStartSingle(0, function()
      RemoveItem(i)
    end)
  end)

end


function Part_6_Init()
  Crafting_Init()
  I006_Init()
end

