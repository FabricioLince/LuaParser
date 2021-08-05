

local Stream = require "parser/string_stream"
local utils = require "utils"
local main_rule = require "main_rule"
local eval = require "evaluator/main"
local Datatable = require "Datatable"
local StringObj = require "evaluator/string_obj"
local Dictionary = require "evaluator/dictionary_obj"
local List = require "evaluator/list_obj"

local Sequence = require "parser/sequence"
local Multiple = require "parser/multiple"
local discard = require "parser/discard"
local token = require "tokens"
local expression = require "expression"


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


local main = function()
	local code = [[
		sqr::(n*n)
		(
			@"6 squared = "
			@:sqr{n=6}
		)

	]]

	local data = Datatable{}
	local tree = extract_tree(code)
	--print(tree)

	if tree then
		local result = eval.evaluate(tree, data)
		print("")
		print("result:", result)
		--print("Final Data:")
		--table.foreach(data, print)
		--print("Behaviours:")
		--table.foreach(data.__behaviours, function(a) print(a) end)
	end
end

main()

local code = [[
		fac:[(?n<2:1)(::fac{n=n-1}*n)+]
		size:(i=0!(i=i+1~?list..i):(i-1))
		ip:(i=1!(i=i+1?n%i==0)?n==i)
		(
			i=2
			!(
				[(ip{n=i}@i@" é primo\n")?1]
				i=i+1
				?i>1
			)
			l = {1 2 3 4}
			i=1
			!~(
				?l..i
				@l..i@"\n"
				i=i+1
			)
			@l
		)
	]]
