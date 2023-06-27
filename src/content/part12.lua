---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

--------------------------------------------------------------------
---@type table<integer, unit>
local bags = {}

---@param player player
---@param unit unit
function SetPlayerBag(player, unit)
  local pid = GetPlayerId(player)
  bags[pid] = unit
end

function GetPlayerBag(player)
  return bags[GetPlayerId(player)]
end

--------------------------------------------------------------------

---@type table<integer, unit>
local units = {}

---@param player player
---@param unit unit
function SetPlayerHero(player, unit)
  local pid = GetPlayerId(player)
  units[pid] = unit
end

---@param player player
function GetPlayerHero(player)
  return units[GetPlayerId(player)]
end

--------------------------------------------------------------------

local function Init_Save()
  --see SavedataGenerator.lua for current saveData format

  ---@param player player
  ---@param save_data saveData
  local function onSaveSuccess(player, save_data)
    Logger.SendInfoLocal(player, "you saved; removing all things you had before")

    for _, item in pairs(save_data.items)do
      RemoveItem(item)
    end

    RemoveUnit(save_data.hero)
    SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, 0)
  end

  Saveloader.RegisterOnSaveSuccessCallback(onSaveSuccess)
end

--------------------------------------------------------------------

local function Init_Load()
  --see SavedataGenerator.lua for current saveData format

  ---@param player player
  ---@param save_data saveData
  local function onLoadSuccess(player, save_data)
    Logger.SendInfoLocal(player, "you loaded; all things are back")

    --update player hero, since old was removed
    SetPlayerHero(player, save_data.hero)

    local x, y = -2350, 1350
    SetUnitPosition(save_data.hero, x, y)

    PanCameraToTimedLocal(player, x, y, 0.2)
  end

  --add callback for loading
  Saveloader.RegisterOnLoadSuccessCallback(onLoadSuccess)
end

local function Init_Misc()
  local id = "h003"
  local id_c = fourcc(id)
  local bag

  bag = CreateUnit(Player(0), id_c, -2950, 900, -25)
  SetPlayerBag(Player(0), bag)

  bag = CreateUnit(Player(1), id_c, -2950, 640, 25)
  SetPlayerBag(Player(1), bag)

end

local function Item_I00N_Init()
  local id = "I00N"

  RegisterItemExEvent(id, EX_EVENT_ITEM_PICKUP, function ()
    local u = GetManipulatingUnit()
    local p = GetOwningPlayer(u)

    SetPlayerHero(p, u)
    Logger.SendInfo("main unit of %s is now %s | %s", GetPlayerName(p), GetUnitName(u), u)
  end)

  RegisterItemExEvent(id, EX_EVENT_ITEM_DROP, function ()
    local u = GetManipulatingUnit()
    local p = GetOwningPlayer(u)

    SetPlayerHero(p, nil)
    Logger.SendInfo("main unit of %s is cleared", GetPlayerName(p))
  end)
end

-- savedata should be somewhat public to access from SavedataGenerator, and accessible by player as key
-- you define how save looks in SavedataGenerator, and allows it to get some public data, like GetPlayerHero and GetPlayerBag defined there
-- then you encode it and save into file
-- after successeful saving, it executes passed callback with all data packed inside, so you can work with it
-- same with loading, all loaded data is packed into table for u to work

function Part_12_Init()
  Init_Save()
  Init_Load()
  Init_Misc()
  Item_I00N_Init()
end
