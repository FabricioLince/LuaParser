
local Patternrule = require "parser/pattern"
local Select = require "parser/select"

local space = Patternrule("^%s", "space")
local integer = Patternrule("^%d+", "integer")
local real = Patternrule("^%d+%.%d+", "real")
local name = Patternrule("^%a[_%w]*", "name")
local string = Patternrule("^\".-\"", "string")

local symbol = function(symbols)
	if type(symbols) == "string" then
		local pat = "^"..symbols:gsub("(.)", "%%%1")
		return Patternrule(pat, "symbol")
	end
	if #symbols == 1 then
		local pat = "^"..symbols[1]:gsub("(.)", "%%%1")
		return Patternrule(pat, "symbol")
	else
		local rule = Select()
		for _, s in ipairs(symbols) do
			local pat = "^"..s:gsub("(.)", "%%%1")
			local opt = Patternrule(pat, "symbol")
			rule:add_rule(opt)
		end
		return rule
	end
end

local reserved = function(str)
	local pattern = str:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
	return Patternrule(pattern, "reserved")
end

local eof = Patternrule("^$", "eof")

return {
	space = space,
	integer = integer,
	real = real,
	name = name,
	string = string,
	symbol = symbol,
	reserved = reserved,
	eof = eof,
}
