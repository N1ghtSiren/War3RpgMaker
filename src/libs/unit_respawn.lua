---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 19.06.2023 20:21
---

---@shape respawnInstance
---@field unitid string
---@field pos_x number
---@field pos_y number
---@field facing number
---@field owner player

---@type table<unit, respawnInstance>
local respawn_points = {}

---@type table<string, number>
local respawn_time_list = {}

---@param unitid string
---@param resp_time_sec number
function RegisterUnitTypeRespawnTime(unitid, resp_time_sec)
  respawn_time_list[fourci(unitid)] = resp_time_sec
end

---@param unit unit
local function SaveRespawnInstance(unit)

  if(respawn_points[unit] ~= nil)then return end

  ---@type respawnInstance
  local resp_instance = {
    unitid = fourci(GetUnitTypeId(unit)),
    pos_x = GetUnitX(unit),
    pos_y = GetUnitY(unit),
    facing = GetUnitFacing(unit),
    owner = GetOwningPlayer(unit),
  }

  respawn_points[unit] = resp_instance
end

---@param unit unit
---@param doRemove boolean
---@return respawnInstance
local function LoadRespawnInstance(unit, doRemove)
  local r_i = respawn_points[unit]
  if(doRemove == true)then respawn_points[unit] = nil end
  return r_i
end

---------------------------------------------------------------------------------------------------

local function StoreInitialUnits()
  local G = CreateGroup()
  GroupEnumUnitsInRange(G, 0, 0, 99999, nil)
  local n = GroupGetCount(G)

  for i = 0, n-1 do
    local u =  GroupGetUnitByIndex(G, i)
    SaveRespawnInstance(u)
  end

  GroupClear(G)
  DestroyGroup(G)
end

local function StoreCreatedUnits()
  local trig = CreateTrigger()
  TriggerRegisterEnterRectSimple(trig, bj_mapInitialPlayableArea)
  TriggerAddAction(trig, function()
    SaveRespawnInstance(GetEnteringUnit())
  end)
end

function Init_UnitRespawn()
  StoreInitialUnits()
  StoreCreatedUnits()

  local function OnDeath()
    local u = GetDyingUnit()
    local unitid = fourci(GetUnitTypeId(u))
    local r_i = LoadRespawnInstance(u, true)
    local resp_time = respawn_time_list[unitid]

    if(respawn_time_list[fourci(unitid)] ~= nil)then
      TimerStartSingle(resp_time, function()
        local u = CreateUnit(r_i.owner, fourcc(r_i.unitid), r_i.pos_x, r_i.pos_y, r_i.facing)
        FullHealUnit(u)
      end)
    end
  end

  RegisterEvent(EVENT_PLAYER_UNIT_DEATH, OnDeath)
end

