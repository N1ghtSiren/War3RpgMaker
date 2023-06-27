---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 16.06.2023 12:35
---

---@alias ex_ability_event integer

---@type ex_ability_event
EX_EVENT_ABILITY_CAST = malloc()      -- EVENT_PLAYER_UNIT_SPELL_CAST
---@type ex_ability_event
EX_EVENT_ABILITY_CAST_END = malloc()  -- EVENT_PLAYER_UNIT_SPELL_ENDCAST
---@type ex_ability_event
EX_EVENT_ABILITY_CHANNEL = malloc()   -- EVENT_PLAYER_UNIT_SPELL_CHANNEL
---@type ex_ability_event
EX_EVENT_ABILITY_EFFECT = malloc()    -- EVENT_PLAYER_UNIT_SPELL_EFFECT
---@type ex_ability_event
EX_EVENT_ABILITY_FINISH = malloc()    -- EVENT_PLAYER_UNIT_SPELL_FINISH
---@type ex_ability_event
EX_EVENT_ABILITY_LEARN = malloc()     -- EVENT_PLAYER_HERO_SKILL


---@type table<string, table<ex_ability_event, FuncList>>
local event_list = {}


--- Registers given ex_ability_c_event, with callback()
--- any params can be grabbed from GetTriggering# natives
---@param aid integer | string
---@param event_type ex_ability_event
---@param callback fun():void
function RegisterAbilityExEvent(aid, event_type, callback)
  local aid = fourci(aid) --we save it as string
  event_list[aid] = event_list[aid] or {}
  event_list[aid][event_type] = event_list[aid][event_type] or {}
  FuncListAdd(event_list[aid][event_type], callback)
end

--- Executes given ex_ability_c_event, sends (unit, aid) into callback
--- since its starting from a trigger, you can grab everything using GetTriggering# natives
---@param aid integer | string
---@param event_type ex_ability_event
local function ExecuteAbilityExEvent(aid, event_type)
  local aid = fourci(aid)

  if(event_list[aid] == nil)then return end
  if(event_list[aid][event_type] == nil)then return end

  local func_list = event_list[aid][event_type]
  if(func_list == nil) then return end

  FuncListExecute(func_list)
end



local init_done = false

--- Init which creates triggers for all of those to work
function Init_AbilityTrigs()
  if(init_done)then return end

  local function OnCast()
    --printdf("OnCast: %s", fourci(GetSpellAbilityId()))
    ExecuteAbilityExEvent(GetSpellAbilityId(), EX_EVENT_ABILITY_CAST)
  end
  RegisterEvent(EVENT_PLAYER_UNIT_SPELL_CAST, OnCast)


  local function OnCastEnd()
    --printdf("OnCastEnd: %s", fourci(GetSpellAbilityId()))
    ExecuteAbilityExEvent(GetSpellAbilityId(), EX_EVENT_ABILITY_CAST_END)
  end
  RegisterEvent(EVENT_PLAYER_UNIT_SPELL_ENDCAST, OnCastEnd)


  local function OnChannel()
    --printdf("OnChannel: %s", fourci(GetSpellAbilityId()))
    ExecuteAbilityExEvent(GetSpellAbilityId(), EX_EVENT_ABILITY_CHANNEL)
  end
  RegisterEvent(EVENT_PLAYER_UNIT_SPELL_CHANNEL, OnChannel)


  local function OnEffect()
    --printdf("OnEffect: %s", fourci(GetSpellAbilityId()))
    ExecuteAbilityExEvent(GetSpellAbilityId(), EX_EVENT_ABILITY_EFFECT)
  end
  RegisterEvent(EVENT_PLAYER_UNIT_SPELL_EFFECT, OnEffect)


  local function OnFinish()
    --printdf("OnFinish: %s", fourci(GetSpellAbilityId()))
    ExecuteAbilityExEvent(GetSpellAbilityId(), EX_EVENT_ABILITY_FINISH)
  end
  RegisterEvent(EVENT_PLAYER_UNIT_SPELL_FINISH, OnFinish)


  local function OnLearn()
    --printdf("OnLearn: %s", fourci(GetLearnedSkill()))
    ExecuteAbilityExEvent(GetLearnedSkill(), EX_EVENT_ABILITY_LEARN)
  end
  RegisterEvent(EVENT_PLAYER_HERO_SKILL, OnLearn)

  init_done = true
end

--[[ order:
OnChannel: A002
OnCast: A002
OnEffect: A002
OnFinish: A002
OnCastEnd: A002
]]

---------------------------------------------------------------------------------------------------
---@alias ex_ability_c_event integer    -- ExAbilityCustomEvent

---@type ex_ability_c_event
EX_EVENT_ABILITY_C_ADD = malloc()       -- hook, UnitAddAbility
---@type ex_ability_c_event
EX_EVENT_ABILITY_C_REMOVE = malloc()    -- hook, UnitRemoveAbility

---@type table<string, table<ex_unit_c_event, FuncList>>
local custom_event_list = {}

--- Registers given ex_ability_c_event, with callback(unit, aid)
--- event starts from hooked function, so you need to pass params into callback
---@param aid integer | string
---@param event_type ex_ability_c_event
---@param callback fun(unit:unit, aid:integer):void
function RegisterAbilityExEvent2(aid, event_type, callback)
  local aid = fourci(aid)

  custom_event_list[aid] = custom_event_list[aid] or {}
  custom_event_list[aid][event_type] = custom_event_list[aid][event_type] or {}
  FuncListAdd(custom_event_list[aid][event_type], callback)
end


--- Executes given ex_ability_c_event, sends (unit, aid) into callback
--- since its not starting from trigger, you need to provide variables by self
---@param aid integer|string
---@param event_type ex_ability_c_event
---@param unit unit
local function ExecuteAbilityExEvent2(aid, event_type, unit)
  local aid = fourci(aid)
  if(custom_event_list[aid] == nil)then return end

  local func_list = custom_event_list[aid][event_type]
  if(func_list == nil) then return end

  FuncListExecute(func_list, unit)
end


local UnitAddAbilityOrigin = UnitAddAbility

--- hook for UnitAddAbility, which also invokes EX_EVENT_ABILITY_C_ADD
---@param u unit
---@param aid integer | string
function UnitAddAbility(u, aid)
  UnitAddAbilityOrigin(u, fourcc(aid))
  ExecuteAbilityExEvent2(aid, EX_EVENT_ABILITY_C_ADD, u)
end


local UnitRemoveAbilityOrigin = UnitRemoveAbility

--- hook for UnitRemoveAbility, which also invokes EX_EVENT_ABILITY_C_REMOVE
---@param u unit
---@param aid integer|string
function UnitRemoveAbility(u, aid)
  ExecuteAbilityExEvent2(aid, EX_EVENT_ABILITY_C_REMOVE, u)
  UnitRemoveAbilityOrigin(u, fourcc(aid))
end

---------------------------------------------------------------------------------------------------
---@type table<number, fun():void>
local init_list = {}

--- registers callback on big ability init list
--- used when you need to change base ability data, before ability appears on any unit
--- e.g. manage ability cooldown from code and not object editor
--- when ExecuteAbilityInitList is called, all list will be called at once
---@param aid integer|string
---@param callback fun():void
function RegisterAbilityInitCallback(aid, callback)
  init_list[fourcc(aid)] = callback
end


local is_inited = false

--- executes all registered init events at once
function Execute_AbilityInitList()
  if(is_inited)then return end

  for _, func in pairs(init_list)do
    func()
  end

  is_inited = true
end