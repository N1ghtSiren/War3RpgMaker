---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 20.06.2023 18:41
---

---@shape statDefinition
---@field codename string
---@field name string
---@field postfix string

---@type table<statKey, statDefinition>
local stat_def = --[[---@type table<statKey, statDefinition> ]] NewOrderedTable()



---@param stat_key statKey
---@return string
function GetStatName(stat_key)
  return stat_def[stat_key] and stat_def[stat_key].codename or "Stat Name Not Added"
end

---@param stat_key statKey
---@param codename string
---@param name string
---@param postfix string
local function RegisterStatDef(stat_key, codename, name, postfix)
  ---@type statDefinition
  local def = { --yes linter, i accept this error
    codename = codename,
    name = name,
    postfix = postfix
  }

  stat_def[stat_key] = def
end



local function InitStatDefinitions()
  RegisterStatDef(STAT_KEY_DAMAGE, "damage", "Урон", "")
  RegisterStatDef(STAT_KEY_ARMOUR, "armour", "Броня", "")
  RegisterStatDef(STAT_KEY_LIFE, "life", "ХП", "")
  RegisterStatDef(STAT_KEY_MANA, "mana", "МП", "")
  RegisterStatDef(STAT_KEY_LIFE_REGEN, "life_regen", "ХП в сек", "")
  RegisterStatDef(STAT_KEY_MANA_REGEN, "mana_regen", "МП в сек", "")
  RegisterStatDef(STAT_KEY_MOVE_SPEED, "move_speed", "Скорость Передвижения", "")
  RegisterStatDef(STAT_KEY_STR, "STR", "Сила", "")
  RegisterStatDef(STAT_KEY_AGI, "AGI", "Ловкость", "")
  RegisterStatDef(STAT_KEY_INT, "INT", "Интеллект", "")
  RegisterStatDef(STAT_KEY_BASE_ATTACKSPEED, "base as", "Базовая Скорость Атаки", "сек")
  RegisterStatDef(STAT_KEY_DPS, "dps", "Урон в секунду", "")

  RegisterStatDef(STAT_KEY_DAMAGE_PERCENT, "damage_percent", "Урон", "%")
  RegisterStatDef(STAT_KEY_ARMOUR_PERCENT, "armour_percent", "Броня", "%")
  RegisterStatDef(STAT_KEY_LIFE_PERCENT, "life_percent", "ХП", "%")
  RegisterStatDef(STAT_KEY_MANA_PERCENT, "mana_percent", "МП", "%")
  RegisterStatDef(STAT_KEY_LIFE_REGEN_PERCENT, "life_regen_percent", "скорость восстановления ХП", "%")
  RegisterStatDef(STAT_KEY_MANA_REGEN_PERCENT, "mana_regen_percent", "скорость восстановления МП", "%")
  RegisterStatDef(STAT_KEY_MOVE_SPEED_PERCENT, "move_speed_percent", "Скорость Передвижения", "%")
  RegisterStatDef(STAT_KEY_STR_PERCENT, "STR_percent", "Сила", "%")
  RegisterStatDef(STAT_KEY_AGI_PERCENT, "AGI_percent", "Ловкость", "%")
  RegisterStatDef(STAT_KEY_INT_PERCENT, "INT_percent", "Интеллект", "%")
  RegisterStatDef(STAT_KEY_ATTACKSPEED_PERCENT, "as_percent", "Скорость Атаки", "%")
  RegisterStatDef(STAT_KEY_DPS_PERCENT, "as_percent", "Урон в секунду", "%")
end
InitStatDefinitions()


--- Returns "MP: +100" or "MP -100" as used with delta value
---@param stat_key statKey
---@param value number
---@return string
function GetStatDeltaDescription(stat_key, value)
  local def = stat_def[stat_key]

  --negative number already contains "-" sign
  local sign = value < 0 and "" or "+"

  local ts = tostring
  local str = ts(def.name) .. ": " .. ts(sign) .. ts(value) .. ts(def.postfix)

  -- fatals in debug-hook mode due to percents in string, upon file loading
  -- but should be much faster
  -- str = string.format("%s: %s%s%s", def.name, sign, value, def.postfix)

  return str
end


--- Returns "MP: 100" or "MP -100" as final value
---@param stat_key statKey
---@param value number
---@return string
function GetStatValueDescription(stat_key, value)
  local def = stat_def[stat_key]

  local ts = tostring
  local str = ts(def.name) .. ": " .. ts(value) .. ts(def.postfix)

  -- fatals in debug-hook mode due to percents in string, upon file loading
  -- but should be much faster
  -- str = string.format("%s: %s%s", def.name, value, def.postfix)
  
  return str
end