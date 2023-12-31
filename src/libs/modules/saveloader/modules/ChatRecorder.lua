---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Siren.
--- DateTime: 26.11.2022 6:32
---

--------------------------------------------------------------------
-- private logic
--------------------------------------------------------------------

---@shape chatRecord
---@field trig trigger
---@field text string

---@type table<integer, chatRecord>
local recorders = {}


---@param player player
---@return boolean, string
local function EndRecord(player)
  local pid = GetPlayerId(player)

  ---@type chatRecord
  local chatRecord

  if(recorders[pid] == nil)then
    Logger.SendInfoLocal(Player(pid), "Вы не стартовали чтение чата для загрузки кода!")
    return false, nil
  end

  chatRecord = recorders[pid]
  recorders[pid] = nil

  DestroyTrigger(chatRecord.trig)

  return true, chatRecord.text
end


---@param player player
---@return boolean
local function StartRecord(player)
  local pid = GetPlayerId(player)

  if(recorders[pid] ~= nil)then
    local str = "Вы уже пытаетесь загрузить код, завершите старый командой '%s' чтобы попробовать снова"

    Logger.SendInfoLocal(Player(pid), str, SAVELOADER_COMMAND_CHAT_END)
    return false
  end

  ---@type chatRecord
  local chat_record = {
    trig = CreateTrigger(),
    text = ""
  }

  recorders[pid] = chat_record

  local msg = "Отправляйте свой код в следующих сообщениях в чат. Вы можете разделять его как хотите, но чтобы он заработал, вам нужно ввести его весь. Как закончите, напишите '%s' для попытки загрузки"
  Logger.SendInfoLocal(Player(pid), msg, SAVELOADER_COMMAND_CHAT_END)

  TriggerRegisterPlayerChatEvent(chat_record.trig, Player(pid), "", false)
  TriggerAddAction(chat_record.trig, function()
    local str = GetEventPlayerChatString()

    if(str ~= SAVELOADER_COMMAND_CHAT_END and str ~= SAVELOADER_COMMAND_CHAT_START)then
      chat_record.text = chat_record.text .. str
      Logger.SendInfoLocal(Player(pid), "часть кода получена, для попытки загрузки введите \'%s\'", SAVELOADER_COMMAND_CHAT_END)
    end

  end)

  return true
end

--------------------------------------------------------------------
-- public functions
--------------------------------------------------------------------

ChatRecorder = {
  StartRecord = StartRecord,
  EndRecord = EndRecord
}