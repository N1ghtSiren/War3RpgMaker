---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 20.06.2023 17:41
---


---@type table<unit, boolean>
local dps_users = {}

---@param unit unit
---@param flag boolean
function RegisterUnitUseDPS(unit, flag)
  dps_users[unit] = flag
end

---@param unit unit
---@return boolean
function IsUnitUsingDPS(unit)
  return dps_users[unit] or false
end

---@param id string
---@param flag boolean
function RegisterUnitTypeUseDPS(id, flag)
  RegisterUnitExEvent2(id, EX_EVENT_UNIT_C_CREATED, function(unit)
    RegisterUnitUseDPS(unit, flag)
  end)
end


local function Init_DPS()
  -- override old updaters to hook them
  -- also as affects dps

  ---@param u unit
  local function OnDPSUpdate(u)
    if(IsUnitUsingDPS(u) == false)then return end

    local stat = GetUnitStat(u, STAT_KEY_DPS)
    local perc = GetUnitStat(u, STAT_KEY_DPS_PERCENT)
    local value = stat * (perc * 0.01)

    local as_cd = GetUnitStat(u, STAT_KEY_BASE_ATTACKSPEED)
    local as_perc = GetUnitStat(u, STAT_KEY_ATTACKSPEED_PERCENT)

    local cd = as_cd / (as_perc * 0.01)

    local aps = 1 / cd
    local dmg = value / aps
    SetUnitBaseDamageByIndex(u, 0, R2I(dmg))
  end

  local OnDamageUpdateOrigin = STATS__FUNC_TABLE[STAT_KEY_DAMAGE]

  ---@param u unit
  local function OnDamageUpdateHook(u)
    if(IsUnitUsingDPS(u))then
      OnDPSUpdate(u)
    else
      OnDamageUpdateOrigin(u)
    end
  end

  RegisterStatUpdater(STAT_KEY_DAMAGE, OnDamageUpdateHook)
  RegisterStatUpdater(STAT_KEY_DAMAGE_PERCENT, OnDamageUpdateHook)

  RegisterStatUpdater(STAT_KEY_DPS, OnDamageUpdateHook)
  RegisterStatUpdater(STAT_KEY_DPS_PERCENT, OnDamageUpdateHook)

  local OnAsUpdateHookOrigin = STATS__FUNC_TABLE[STAT_KEY_BASE_ATTACKSPEED]
  ---@param u unit
  local function OnAsUpdateHook(u)
    OnAsUpdateHookOrigin(u)
    OnDPSUpdate(u)
  end

  RegisterStatUpdater(STAT_KEY_BASE_ATTACKSPEED, OnAsUpdateHook)
  RegisterStatUpdater(STAT_KEY_ATTACKSPEED_PERCENT, OnAsUpdateHook)

end

Init_DPS()

---------------------------------------------------------------------------------------------------

---@param dps number
function RegisterDefaultUnitStats_D(unitid, dps)
  local unitid = fourci(unitid)

  DEFAULT_UNIT_STATS[unitid] = DEFAULT_UNIT_STATS[unitid] or NewOrderedTable()

  DEFAULT_UNIT_STATS[unitid][STAT_KEY_DPS] = dps
end

---------------------------------------------------------------------------------------------------

---@param itemid integer|string
---@param dps_perc number
---@param dps_perc number
function RegisterItemStats_D(itemid, dps, dps_perc)
  local itemid = fourci(itemid)

  STATS__ITEM_TABLE[itemid] = STATS__ITEM_TABLE[itemid] or NewOrderedTable()

  STATS__ITEM_TABLE[itemid][STAT_KEY_DPS] = dps or 0
  STATS__ITEM_TABLE[itemid][STAT_KEY_DPS_PERCENT] = dps_perc or 0
end