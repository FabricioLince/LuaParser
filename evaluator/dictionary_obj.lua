
local copy_tbl = function(tbl)
	local cpy = {}
	for k, v in pairs(tbl) do
		cpy[k] = v
	end
	return cpy
end
local Dictionary
local dictionary_metatable = {
	__tostring = function(dic)
		local s = "{"
		for k, v in pairs(dic) do
			s= s..tostring(k)..":"..tostring(v)..";"
		end
		return s.."}"
	end,
	__add = function(dic, item)
		local cpy = Dictionary(copy_tbl(dic))
		table.insert(cpy, item)
		return cpy
	end,
}
Dictionary = function(init)
	return setmetatable(init, dictionary_metatable)
end

return Dictionary
