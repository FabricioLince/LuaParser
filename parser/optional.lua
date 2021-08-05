
local rule_to_string = require "parser/rule_base"
local Tree = require "parser/tree"

local execute_optional = function(rule, stream)
	local p = stream.pos
	local tree = Tree(rule.name)
	local result = rule.child(stream)
	if result then
		tree:add_child(result)
	end
	return tree
end
local Optional = function(name, rule)
	if not rule then
		rule = name
		name = rule.name
	end
	local rule = {
		type = "Optional",
		name = name,
		child = rule,
		execute = execute_optional
	}
	return setmetatable(rule, {
		__call = execute_optional,
		__tostring = rule_to_string,
	})
end

return Optional
