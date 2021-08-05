
local copy_tbl = function(tbl)
	local cpy = {}
	for k, v in pairs(tbl) do
		cpy[k] = v
	end
	return cpy
end
local List
local list_metatable = {
	__tostring = function(list)
		local s = "{"
		for i, v in ipairs(list) do
			s = s .. tostring(v)
			if i < #list then
				s = s.." "
			end
		end
		s = s.."}"
		return s
	end,
	__add = function(list, item)
		local cpy = List(copy_tbl(list))
		table.insert(cpy, item)
		return cpy
	end,
	__sub = function(list, item)
		local cpy = List()
		for i, v in ipairs(list) do
			if v ~= item then
				table.insert(cpy, v)
			end
		end
		return cpy
	end,
	__mod = function(list, item)
		for i, v in ipairs(list) do
			if v == item then
				return i
			end
		end
	end,
	-- new index only works with absent indexes
	__newindex = function(list, index, value)
		print("here ", list, index, value)
		if value == nil then
			table.remove(list, index)
		else
			rawset(list, index, value)
		end
	end
}

local add_item = function(list, item)
	table.insert(list, item)
end

List = function(init)
	return setmetatable(init or {}, list_metatable)
end

return List
