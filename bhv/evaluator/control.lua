
local Datatable = require "bhv/Datatable"

eval = {}

eval.sequencer = function(tree, data)
	local child_data = Datatable({}, data)
	for i, c in ipairs(tree.children[1].children) do
		if not eval.evaluate(c, child_data) then
			return false
		end
	end
	return true
end

eval.selector = function(tree, data)
	local child_data = Datatable({}, data)
	for i, c in ipairs(tree.children[1].children) do
		if eval.evaluate(c, child_data) then
			return true
		end
	end
	return false
end

eval.repeat_true = function(tree, data)
	local r
	while not r do
		r = eval.evaluate(tree.children[1], data)
	end
	return true
end

eval.invert = function(tree, data)
	return not eval.evaluate(tree.children[1], data)
end

return eval
