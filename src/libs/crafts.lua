---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 19.06.2023 14:10
---

---@type craftRecipe[]
local craft_list = --[[---@type craftRecipe[] ]] NewOrderedTable()

---@shape craftRecipe
---@field result string
---@field mats string[]

---@param result string|integer
---@param mat1 string|integer
---@param mat2 string|integer
---@param mat3 string|integer
---@param mat4 string|integer
---@param mat5 string|integer
---@param mat6 string|integer
local function NewCraftRecipe(result, mat1, mat2, mat3, mat4, mat5, mat6)
  ---@type craftRecipe
  local recipe = {
    result = fourci(result),
    mats = {}
  }

  --дырки в аргументах? пооооооооооооооохуй
  table.insert(recipe.mats, mat1 and fourci(mat1))
  table.insert(recipe.mats, mat2 and fourci(mat2))
  table.insert(recipe.mats, mat3 and fourci(mat3))
  table.insert(recipe.mats, mat4 and fourci(mat4))
  table.insert(recipe.mats, mat5 and fourci(mat5))
  table.insert(recipe.mats, mat6 and fourci(mat6))

  table.insert(craft_list, recipe)
end


--- мне похуй как ты будешь хранить данные, так что наслаждайся видом
---@overload fun(result:string|integer, mat1:string|integer)
---@overload fun(result:string|integer, mat1:string|integer, mat2:string|integer)
---@overload fun(result:string|integer, mat1:string|integer, mat2:string|integer, mat3:string|integer)
---@overload fun(result:string|integer, mat1:string|integer, mat2:string|integer, mat3:string|integer, mat4:string|integer)
---@overload fun(result:string|integer, mat1:string|integer, mat2:string|integer, mat3:string|integer, mat4:string|integer, mat5:string|integer)
---@overload fun(result:string|integer, mat1:string|integer, mat2:string|integer, mat3:string|integer, mat4:string|integer, mat5:string|integer, mat6:string|integer)
---@param result string|integer
---@param mat1 string|integer
---@param mat2 string|integer
---@param mat3 string|integer
---@param mat4 string|integer
---@param mat5 string|integer
---@param mat6 string|integer
function RegisterCraftRecipe(result, mat1, mat2, mat3, mat4, mat5, mat6)
  NewCraftRecipe(result, mat1, mat2, mat3, mat4, mat5, mat6)
end

---------------------------------------------------------------------------------------------------

---@param itemid_list item[]
---@return craftRecipe[]
local function ParseCraftRecipes(itemid_list)
  local results = {}

  for _, craftRecipe in pairs(craft_list)do

    --printdf("checking craft recipe: %s", craftRecipe.result)
    local mats = 0

    for _, v in pairs(itemid_list)do

      if(tableContains(craftRecipe.mats, v) == true)then
        mats = mats + 1
        --printdf("unit has %s/%s items for %s", mats, #craftRecipe.mats, craftRecipe.result)

        if(mats == #craftRecipe.mats)then
          --printdf("unit can craft item: %s", craftRecipe.result)

          --ignore duplicates
          if(tableContains(results, craftRecipe.result) == false)then
            table.insert(results, craftRecipe)
          end
        end
      end
    end
  end

  return results
end

--- parses unit inventory and returns list of possible crafts
---@param u unit
---@return craftRecipe[]
function GetPossibleCrafts(u)

  local itemid_list = {}

  for i = 0, 5 do
    local item = UnitItemInSlot(u, i)
    if(item ~= nil)then
      table.insert(itemid_list, fourci(GetItemTypeId(item)))
    end
  end

  return ParseCraftRecipes(itemid_list)
end

---e.g. if you have bag with pages or multiple bags,
---you may want to provide all items by self,
---to get list of possible crafts
---@param item_list item[]
---@return craftRecipe[]
function GetPossibleCrafts2(item_list)
  local itemid_list = {}

  for _, item in pairs(item_list) do
      table.insert(itemid_list, fourci(GetItemTypeId(item)))
  end

  return ParseCraftRecipes(itemid_list)
end

---------------------------------------------------------------------------------------------------

---@param unit unit
---@param item_list item[]
---@param recipe craftRecipe
local function CraftItem(unit, item_list, recipe)
  --final check?
  ---@type item[]
  local items_to_remove = {}

  local mats = 0
  for _, item in pairs(item_list)do
    if(tableContains(recipe.mats, fourci(GetItemTypeId(item))))then
      mats = mats + 1
      table.insert(items_to_remove, item)
      if(mats == #recipe.mats)then
        break
      end
    end
  end

  if(mats ~= #recipe.mats)then
    printd("You have no ingridients to craft this")
    return
  end

  for _, v in pairs(items_to_remove)do
    RemoveItem(v)
  end

  UnitAddItem(unit, CreateItem(fourcc(recipe.result), 0, 0))
end

---shows crafting dialog to owning of unit, parsing inventory of given unit
---@param u unit
function ShowCraftingDialog(u)
  local craftable_list = GetPossibleCrafts(u)

  local item_list = {}
  for i = 0, 5 do
    local item = UnitItemInSlot(u, i)
    if(item ~= nil)then
      table.insert(item_list, item)
    end
  end

  --create crafting dialog
  local d = ExDialogCreate("Crafting")

  for _, recipe in ipairs(craftable_list) do
    local itemid = recipe.result

    ExDialogAddButton(d, GetObjectName(fourcc(itemid)), 0, true, function()
      CraftItem(u, item_list, recipe)
    end)
  end

  ExDialogAddExit(d)
  DialogDisplay(GetOwningPlayer(u), d, true)
end

---shows crafting dialog to owning of unit, parsing given item list
---e.g. if you have bag with pages or multiple bags
---you may want to provide all items by self
---

---@param u unit
---@param item_list item[]
function ShowCraftingDialog2(u, item_list)
  local craftable_list = GetPossibleCrafts2(item_list)

  --create crafting dialog
  local d = ExDialogCreate("Crafting")

  for _, recipe in ipairs(craftable_list) do
    local itemid = recipe.result

    ExDialogAddButton(d, GetObjectName(fourcc(itemid)), 0, true, function()
      CraftItem(u, item_list, recipe)
    end)
  end

  ExDialogAddExit(d)
  DialogDisplay(GetOwningPlayer(u), d, true)
end

---------------------------------------------------------------------------------------------------


---@param player player
---@param recipe craftRecipe
function ShowRecipeToPlayer(player, recipe)
  local format = "%s = " .. string.rep("|cffff0000[|r%s|cffff0000]|r |cffffff00+|r ", #recipe.mats)
  format = string.sub(format, 0, #format - 15)


  local item_names = NewOrderedTable()

  for _, itemid in pairs(recipe.mats)do
    table.insert(item_names, ItemIdToItemName(itemid))
  end

  local str = string.format(format, ItemIdToItemName(recipe.result), table.unpack(item_names))

  if(GetLocalPlayer() == player)then
    printd(str)
  end
end

---@param player player
---@param item item
function ShowItemCrafts(player, item)
  local itemid = fourci(GetItemTypeId(item))

  ---@type craftRecipe[]
  local possible_crafts = --[[---@type craftRecipe[] ]]  NewOrderedTable()

  for _, recipe in pairs(craft_list) do
    if(tableContains(recipe.mats, itemid)== true or itemid == recipe.result)then
      table.insert(possible_crafts, recipe)
    end
  end

  local str = string.format("Showing %s recipes from %s", #possible_crafts, ItemIdToItemName(itemid))
  DisplayTimedTextToPlayerC(player, str)

  for _, recipe in pairs(possible_crafts)do
    ShowRecipeToPlayer(player, recipe)
  end

  DisplayTimedTextToPlayerC(player, " ")
end

---@param player player
function ShowAllCrafts(player)
  local str = string.format("Showing %s recipes from all recipes", #craft_list)
  DisplayTimedTextToPlayerC(player, str)

  for _, recipe in pairs(craft_list) do
    ShowRecipeToPlayer(player, recipe)
  end

  DisplayTimedTextToPlayerC(player, " ")
end