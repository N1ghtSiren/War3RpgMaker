
---@alias msgType 1|2|3
---@type msgType
local type_info, type_debug, type_error = 1, 2, 3


---@shape msgData
---@field duration number
---@field prefix string

---@type table<msgType, msgData>
local msgData = {}
msgData[type_info] = {duration = 20, prefix = "|cffffff00[info]|r: "}
msgData[type_debug] = {duration = 40, prefix = "|cff8000ff[debug]|r: "}
msgData[type_error] = {duration = 60, prefix = "|cffff0000[game error]|r: "}
--ебал линтер нахуй, заебало


local on_error_traceback = false

---@param state boolean
local function SetErrorTraceback(state)
    on_error_traceback = state
    printdf("on error traceback: %s", state and "enabled" or "disabled")
end

---@param msg_type msgType
---@param format string
---@vararg any
local function BuildString(msg_type, format, ...)
    local msg
    local len = select("#", ...)

    if(len == 0)then
        msg = format
    else
        msg = string.format(format, ...)
    end

    msg = msgData[msg_type].prefix .. tostring(msg)
    return msg
end

---@param msg_type msgType
---@param format string
---@vararg any
local function SendString(msg_type, format, ...)
    local msg = BuildString(msg_type, format, ...)
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, msgData[msg_type].duration, msg)
    printc(msg)
end


---@param msg_type msgType
---@param player player
---@param format string
---@vararg any
local function SendStringLocal(msg_type, player, format, ...)
    local msg = BuildString(msg_type, format, ...)
    DisplayTimedTextToPlayer(player, 0, 0, msgData[msg_type].duration, msg)
    printc(msg)
end


---@param player player
---@param format string
---@vararg any
local function SendInfoLocal(player, format, ...)
    SendStringLocal(type_info, player, format, ...)
end

---@param player player
---@param format string
---@vararg any
local function SendDebugLocal(player, format, ...)
    SendStringLocal(type_debug, player, format, ...)
end

---@param player player
---@param format string
---@vararg any
local function SendErrorLocal(player, format, ...)
    SendStringLocal(type_error, player, format, ...)
end

---@param format string
---@vararg any
---@overload fun(str: string)
local function SendInfo(format, ...)
    SendString(type_info, format, ...)
end

---@param format string
---@vararg any
---@overload fun(str: string)
local function SendDebug(format, ...)
    SendString(type_debug, format, ...)
end


---@param format string
---@vararg any
---@overload fun(str: string)
local function SendError(format, ...)
    SendString(type_error, format, ...)

    if(on_error_traceback)then
        printd("error traceback enabled, check console")
        printc(debug.traceback())
    end
end

--------------------------------------------------------------------

Logger = {
    SendInfoLocal = SendInfoLocal,
    SendDebugLocal = SendDebugLocal,
    SendErrorLocal = SendErrorLocal,
    SendInfo = SendInfo,
    SendDebug = SendDebug,
    SendError = SendError,
    SetErrorTraceback = SetErrorTraceback,
}

return Logger