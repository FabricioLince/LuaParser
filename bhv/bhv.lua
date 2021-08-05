

local Stream = require "parser/string_stream"

local Datatable = require "bhv/Datatable"
local eval = require "bhv/evaluator/main"
local main_rule = require "bhv/rules/main_rule"
local utils = require "bhv/utils"

local extract_tree = function(code, rule)
	if not rule then
		rule = main_rule
	end
	local stream = Stream(code)

	local status, tree = pcall(rule, stream)
	if status then
		utils.remove_empty_ops(tree)
		utils.move_up_only_children(tree)
		return tree
	else
		print("Fatal:", tree)
	end
end

local evaluate = function(tree, data)
	if not data then data = Datatable{} end
	return eval.evaluate(tree, data), data
end

return {
	extract_tree = extract_tree,
	evaluate = evaluate,
}
