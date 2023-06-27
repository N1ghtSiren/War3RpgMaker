---
--- Generated by Luanalysis
--- Created by Siren.
--- DateTime: 18.06.2023 23:57
---

---@param unit unit
local function Unit_Hblm_Create(unit)

  --ressurect on death
  RegisterUnitExEvent(unit, EX_EVENT_UNIT_DEATH, function()
    ReviveHero(unit, -2340, 1400, true)
    PanCameraToTimedLocal(GetOwningPlayer(unit), GetUnitX(unit), GetUnitY(unit), 0.2)
    Logger.SendInfoLocal(GetOwningPlayer(unit), "you died, but dev allows you to ressurect!")
  end)

  SetUnitDamageDicesByIndex(unit, 0, 1)
  SetUnitDamageDicesSideByIndex(unit, 0, 1)
end


local function Unit_Hblm_Init()
  local id = "Hblm"

  RegisterDefaultUnitStats_A(id, 30, 5, 100, 100, 5, 5, 250)
  RegisterDefaultUnitStats_B(id, 15, 15, 15)
  RegisterDefaultUnitStats_C(id, 1.7)
  RegisterDefaultUnitStats_D(id, 0)

  RegisterUnitExEvent2(id, EX_EVENT_UNIT_C_CREATED, Unit_Hblm_Create)
end


local function SendWelcomeMessage()
  local message = "Welcome to SirenRpgMaker"
  .. "\nThat s your main unit, and content is split into parts for you to explore"
  .. "\nEnjoy looking at how it works, how it looks inside"
  .. "\nAnd making your own map!"

  DisplayTimedTextToPlayer(Player(0), 0, 0, 60, message)
  DisplayTimedTextToPlayer(Player(1), 0, 0, 60, message)
end


local function RemoveFogOfWar()
  FogMaskEnable(false)
  FogEnable(false)
end


local function CreateUnits()
  local id = "Hblm"

  for i = 0, 1 do
    local u = CreateUnit(Player(i), id, -2350+(200*i), 1350, 0)

    if(GetLocalPlayer() == GetOwningPlayer(u))then
      SelectUnit(u, true)
      PanCameraToTimed(GetUnitX(u), GetUnitY(u), 0.2)
    end

  end
end


function Part_0_Init()
  RemoveFogOfWar()
  Unit_Hblm_Init()
  SendWelcomeMessage()

  TimerStartSingle(1, CreateUnits)
end