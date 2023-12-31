---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Siren.
--- DateTime: 15.06.2023 6:23
---

--InitDebugHooks()

SDoFile("libs\\modules\\Benchmark.lua")
SDoFile("libs\\modules\\Logger.lua")
--
SDoFile("libs\\basic.lua")
--
SDoFile("libs\\modules\\OrderedTable.lua")
SDoFile("libs\\low_level.lua")
--
SDoFile("libs\\modules\\FuncList.lua")
--
SDoFile("libs\\abils.lua")
SDoFile("libs\\items.lua")
SDoFile("libs\\units.lua")
SDoFile("libs\\players.lua")
--
SDoFile("libs\\modules\\ChatCommandList.lua")
--
SDoFile("libs\\unit_events_on_items.lua")
--
SDoFile("libs\\stats\\stats.lua")
SDoFile("libs\\stats\\stat_definitions.lua")
SDoFile("libs\\stats\\itemstats.lua")
SDoFile("libs\\stats\\unitstats.lua")
SDoFile("libs\\stats\\stat_dps.lua")
--
SDoFile("libs\\ex_dialog.lua")
--
SDoFile("libs\\modules\\saveloader\\saveloader.lua")
--
SDoFile("libs\\crafts.lua")
--
SDoFile("libs\\unit_respawn.lua")
SDoFile("libs\\unit_loot.lua")
--
SDoFile("libs\\item_description.lua")
--
SDoFile("content\\content.lua")


TimerStart(CreateTimer(), 1, false, function()
  Init_AbilityTrigs()                             -- abils.lua
  Init_ItemTrigs()                                -- items.lua
  Init_UnitTrigs()                                -- units.lua
  Init_PlayerTrigs()                              -- players.lua
  --
  Init_CallbacksOnUnitEventOnItems()              -- unit_events_on_items.lua
  Init_ItemStatUpdater()                          -- itemstats.lua
  ChatCommandList.Init()                          -- chatCommandList.lua
  --
  Saveloader.Init()                               -- saveloader.lua
  Init_UnitLoot()                                 -- unit_loot.lua
  Init_UnitRespawn()                              -- unit_respawn.lua
  --
  ShowUnitstatWarns(false)
  Init_Content()                                  -- content folder
  --
  -- should be called after all unit stats will be registered in InitContent
  Init_InitialUnitStats()                         -- unitstats.lua
  --
  Execute_UnitInitList()                          -- units.lua
  Execute_ItemInitList()                          -- items.lua
  Execute_AbilityInitList()                       -- abils.lua
  Execute_RebuildItemDescriptions()               -- item_description.lua
  --
  ExecuteFuncForAllInitialUnits()                 -- low_level.lua
  --

  --[[
  команды чата - более компактный вид отображения?

  RegisterItemEquipRequirements?
    item equip requirements callback(unit, item)?
      if callback(...) == false then -> DropItem instantly?
  ]]
end)