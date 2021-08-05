

local rule_to_string = require "parser/rule_base"
local Tree = require "parser/tree"

local execute_select = function(rule, stream)
	for i, tt in ipairs(rule.rules) do
		local result = tt(stream)
		if result then
			return result
		end
	end
end
local add_rule = function(sel, child, pos)
	if pos then
		table.insert(sel.rules, pos, child)
	else
		table.insert(sel.rules, child)
	end
end
local Select = function(rules)
	local rule = {
		type = "Select",
		rules = rules or {},
		execute = execute_select,
		add_rule = add_rule,
	}
	return setmetatable(rule, {
		__call = execute_select,
		__tostring = rule_to_string,
	})
end

return Select
