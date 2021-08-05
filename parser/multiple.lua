
local rule_to_string = require "parser/rule_base"
local Tree = require "parser/tree"


local execute_multiple = function(rule, stream)
	local p = stream.pos
	local tree = Tree(rule.name)
	local found_amount = 0
	local result = rule.child(stream)
	while result do
		tree:add_child(result)
		result = rule.child(stream)
		found_amount = found_amount + 1
	end
	if found_amount >= rule.min_amount then
		return tree
	end
	stream.pos = p
end
local Multiple = function(name, min_amount, rule)
	if not rule then
		error("can't create Multiple rule without child")
	end
	local rule = {
		type = "Multiple",
		name = name,
		child = rule,
		min_amount = min_amount,
		execute = execute_multiple
	}
	return setmetatable(rule, {
		__call = execute_multiple,
		__tostring = rule_to_string,
	})
end

return Multiple
