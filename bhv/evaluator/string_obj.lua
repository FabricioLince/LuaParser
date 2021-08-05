
local is_string_obj = function(obj)
	return type(obj) == "table" and obj.__is_str
end
local my_to_string = function(obj)
	if is_string_obj(obj) then
		return obj.str
	end
	return tostring(obj)
end
local StringObj
local string_obj_metatable = {
	__tostring = function(str)
		--return "`"..str.str.."`"
		return str.str
	end,
	__index = function(str, index)
		if type(index) == "number" then
			return StringObj(str.str:sub(index, index))
		end
		return str
	end,
	__add = function(str, other)
		--print("adding", str, "+", other)
		local s1 = my_to_string(str)
		local s2 = my_to_string(other)
		return StringObj(s1..s2)
	end,
	__mul = function(str, other)
		print("mult", str, "*", other)
		if is_string_obj(str) then
			if type(other) == "number" then
				local r = ""
				for i=1, other do
					r = r .. str.str
				end
				return StringObj(r)
			end
		end
		return str
	end,
	__eq = function(str, other)
		print("eq", str, other)
		if is_string_obj(str) then
			if is_string_obj(other) then
				return str.str == other.str
			end
		end
		return false
	end
}
StringObj = function(init)
	init = init or ""
	init = init:gsub("\\n", [[

]])
	local s = {
		str = tostring(init),
		__is_str = true,
		}
	return setmetatable(s, string_obj_metatable)
end

return StringObj
