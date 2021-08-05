

local rule_to_string = require "parser/rule_base"
local Tree = require "parser/tree"

local execute_sequence = function(seq, stream)
	local p = stream.pos
	local tree = Tree(seq.name)
	local cp = nil
	for i, rule in ipairs(seq.rules) do
		if rule.type == "CheckPoint" then
			cp = rule
		else
			local child = rule(stream)
			if child then
				if type(rule) ~= "table" or not rule.discard then
					tree:add_child(child)
				end
			else
				if cp then

					local err = cp.msg
					if not err then
						err = "Error constructing " .. seq.name
					end
					err = err.." @("..tostring(stream:line_number())..", "..tostring(stream:col_number())..")"

					error(err, 999)
				else
					stream.pos = p
					return
				end
			end
		end
	end
	return tree
end
local Sequence = function(name, rules)
	local rule = {type="Sequence",name = name, rules = rules or {}, execute=execute_sequence}
	return setmetatable(rule, {
		__call = execute_sequence,
		__tostring = rule_to_string,
	})
end

return Sequence
