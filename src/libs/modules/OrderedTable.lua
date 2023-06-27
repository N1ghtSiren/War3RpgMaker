-- https://github.com/Vlod-github/Ordered-table/blob/master/source/OrderedTable.lua

if NewOrderedTable then return end

local global_metatable, unique_id = {}, {}

---@alias orderedTable<K, V> table

---@return any[]
function NewOrderedTable()
	local mt = {__metatable = global_metatable}

	local first = unique_id
	local last = first
	local count = 0
	local nextKey, prevKey = {}, {}
	local orig = {}

	function mt.__len(self) return count end

	function mt:__index(key) return orig[key] end

	function mt:__newindex(key, value)
		if value == nil then
			if orig[key] ~= nil then -- delete key
				local pk = prevKey[key]
				local nk = nextKey[key]
				if nk == nil then -- key == last
					last = pk
				else
					prevKey[nk] = pk
				end
				nextKey[pk] = nk

				count = count - 1
				nextKey[key] = nil
				prevKey[key] = nil
			end
		elseif orig[key] == nil then -- is new key
			nextKey[last] = key
			prevKey[key] = last
			last = key
			count = count + 1
		end
		orig[key] = value
	end

	local function __pairs(self)
		local key = first
		return function()
			key = nextKey[key]
			return key, orig[key]
		end
	end

	mt.__ipairs = __pairs
	mt.__pairs = __pairs

	return setmetatable({}, mt)
end

--[[
оставить звёздочку и иссуе про тайпинги
]]