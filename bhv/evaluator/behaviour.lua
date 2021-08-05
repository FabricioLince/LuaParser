
local Datatable = require "bhv/Datatable"
eval = {}


eval.behaviour_def = function(tree, data)
	--print(tree)
	local bhv = {}
	bhv.name = tree.children[1].str
	bhv.tree = tree.children[2]
	data.__behaviours[bhv.name] = bhv.tree
end

eval.args = function(tree, data, child_data)
	--print(tree)
	if tree.name == "attr" then
		eval.special_attr(tree, data, child_data)
	else
		for i, c in ipairs(tree.children) do
			eval.special_attr(c, data, child_data)
		end
	end
end

eval.behaviour_call = function(tree, data)
	--print(tree)
	local b_name = tree.children[1].str
	local bhv = data.__behaviours[b_name]
	if bhv then
		local child_data = Datatable({__bhv=b_name, __behaviours = data.__behaviours})
		eval.args(tree.children[2], data, child_data)
		local result = eval.evaluate(bhv, child_data)
		if child_data[b_name] then
			data[b_name] = child_data[b_name]
		end
		return result
	end
	--print(tree)
	--print("no such behaviour", b_name)
	if data.__bhv then
		--print("from ", data.__bhv)
	end
end

eval["return"] = function(tree, data)
	--print(tree)
	local value = eval.pre_evaluate(tree.children[1], data)
	--print("returning ", value)
	if data.__bhv then
		--print("bhv:", data.__bhv)
		data:__global()[data.__bhv] = value
		return true
	end
end

return eval
