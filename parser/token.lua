
local token_metatable = {
	__tostring = function(token)
		local s = ""..token.name..":'"..token.str.."'"
		if token.start then
			return s .. "["..tostring(token.start).."]"
		end
		return s
	end
}
local Token = function(name, data)
	data.name = name
	return setmetatable(data, token_metatable)
end

return Token
