---@shape chatCommandTokens
---@field tokens string[]
---@field depth number


---@shape chatCommand
---@field token_list chatCommandTokens[]
---@field description string
---@field action fun(player: player, args: string): void


ChatCommandList = {}


---@type chatCommand[]
local cmd_list = --[[---@type chatCommand[] ]] NewOrderedTable()


---@param str string
---@return chatCommandTokens
ChatCommandList.SplitToTokens = function(str)
  local t = {}

  string.gsub(str, "%S+", function(d)
    table.insert(t, d)
    return nil
  end)

  return { tokens = t, depth = #t }
end

---@param tokens_a chatCommandTokens
---@param tokens_b chatCommandTokens
---@param depth number
---@return boolean
ChatCommandList.CompareTokens = function(tokens_a, tokens_b, depth)
  for i = 1, depth do
    if(tokens_a.tokens[i] ~= tokens_b.tokens[i])then return false end
  end

  return true
end

---@param player player
ChatCommandList.PrintAll = function(player)

  for _, cmd in pairs(cmd_list)do
    local str = "chat command\n"

    for i = 1, #cmd.token_list do
      local tokens = cmd.token_list[i]
      local depth = tokens.depth
      local separator = " "
      local t_str = ""

      for j = 1, #tokens.tokens do
        t_str = t_str .. separator .. tokens.tokens[j]
      end

      --remove first space
      t_str = string.sub(t_str, #separator+1)

      str = str .. string.format("[%s] '%s': %s \n", depth, t_str, cmd.description)
    end

    Logger.SendInfoLocal(player, str .. "\n")
  end
end

---@param player player
---@param str string
ChatCommandList.Process = function(player, str)
  local msg_t = ChatCommandList.SplitToTokens(str)

  for _, cmd in pairs(cmd_list)do
    for i = 1, #cmd.token_list do
      local tokens = cmd.token_list[i]

      if(ChatCommandList.CompareTokens(tokens, msg_t, tokens.depth))then
        local _, last = string.find(str, tokens.tokens[tokens.depth])
        local args = string.sub(str, last+2, string.len(str))

        cmd.action(player, args)
        return
      end
    end
  end

end

---@param action fun(player: player, args: string): void
---@param description string
---@param commands string[]
ChatCommandList.AddCommand = function(action, description, commands)
  ---@type chatCommand
  local command = {
    description = description,
    action = action,
    token_list = {},
  }

  local values = tableValuesToSortedTable(commands)

  for _, str in ipairs(values) do
    table.insert(command.token_list, ChatCommandList.SplitToTokens(str))
  end

  table.insert(cmd_list, command)
end


ChatCommandList.Init = function()
  RegisterPlayerExEvent(EX_EVENT_PLAYER_CHAT, function ()
    local p = GetTriggerPlayer()
    local str = GetEventPlayerChatString()

    ChatCommandList.Process(p, str)
  end)
end


return ChatCommandList