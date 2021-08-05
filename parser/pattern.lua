
local rule_to_string = require "parser/rule_base"
local Tree = require "parser/tree"
local Token = require "parser/Token"


local PatternToken = function(stream, name, pattern)
	stream:get_pattern("^%s*")
	if pattern:sub(1, 1) ~= "^" then
		pattern = "^"..pattern
	end
	local t = stream:get_pattern(pattern)
	if t then
		return Token(name, t)
	end
end

local execute_patternrule = function(rule, stream)
	return PatternToken(stream, rule.name, rule.pattern)
end

local __tostring = function(rule)
	return tostring(rule.name)..":"..rule.pattern
end

local Patternrule = function(pattern, name)
	local rule = {
		type = "Patternrule",
		name = name or "",
		pattern = pattern,
		discard = name==nil,
		execute = execute_patternrule
	}
	return setmetatable(rule, {
		__call = execute_patternrule,
		__tostring = __tostring,
	})
end

return Patternrule
