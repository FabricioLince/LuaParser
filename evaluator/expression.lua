
local StringObj = require "evaluator/string_obj"
local List = require "evaluator/list_obj"

local eval = {}

local pre_evaluate = function(tree, data)
	if tree.name == "behaviour_call" then
		eval.evaluate(tree, data)
		return data[tree.children[1].str]
	end
	return eval.evaluate(tree, data)
end
eval.pre_evaluate = pre_evaluate


eval.expression = function(tree, data)
	local value = pre_evaluate(tree.children[1], data)
	if #tree.children > 1 then
		for i, op in ipairs(tree.children[2].children) do
			if table.has({"and", "&"}, op.children[1].str) then
				value = value and pre_evaluate(op.children[2], data)
			elseif table.has({"or", "|"}, op.children[1].str) then
				value = value or pre_evaluate(op.children[2], data)
			end
		end
	end
	return value
end

eval.comparation = function(tree, data)
	local value = pre_evaluate(tree.children[1], data)
	if value == nil then return nil end
	for i, op in ipairs(tree.children[2].children) do
		local operand = pre_evaluate(op.children[2], data)
		if operand == nil then return nil end

		if op.children[1].str == ">" then
			value = value > operand
		elseif op.children[1].str == "<" then
			value = value < operand
		elseif op.children[1].str == ">=" then
			value = value >= operand
		elseif op.children[1].str == "<=" then
			value = value <= operand
		elseif op.children[1].str == "==" then
			value = value == operand
		end
	end
	return value
end

eval.multiplication = function(tree, data)
	local value = pre_evaluate(tree.children[1], data)
	if value == nil then return nil end

	for i, op in ipairs(tree.children[2].children) do
		local operand = pre_evaluate(op.children[2], data)
		if operand == nil then return nil end

		if op.children[1].str == "*" then
			value = value * operand
		elseif op.children[1].str == "/" then
			value = value / operand
		elseif op.children[1].str == "%" then
			value = value % operand
		end
	end
	return value
end

eval.addition = function(tree, data)
	local value = pre_evaluate(tree.children[1], data)
	if value == nil then return nil end

	for i, op in ipairs(tree.children[2].children) do
		local operand = pre_evaluate(op.children[2], data)
		if operand == nil and not value.__is_str then
			return nil
		end

		if op.children[1].str == "+" then
			value = value + operand
		elseif op.children[1].str == "-" then
			value = value - operand
		end
	end
	return value
end

eval.signed_value = function(tree, data)
	local value = pre_evaluate(tree.children[2], data)
	if tree.children[1].str == "-" then
		return value * -1
	end
	return value
end

eval.integer = function(tree, data)
	return tonumber(tree.str)
end
eval.real = function(tree, data)
	return tonumber(tree.str)
end
eval.string = function(tree, data)
	return StringObj(tree.str:sub(2, tree.str:len()-1))
end

eval.var_access = function(tree, data)
	local var_name = tree.children[1].str
	local value = data[var_name]

	if tree:get("indexes") then
		for i, index in ipairs(tree:get("indexes").children) do
			if index.children[1].name == "name" then
				local index_name = index.children[1].str
				--print("accessing "..index_name.." of "..tostring(value))
				value = value[index_name]

			elseif index.children[1].name == "indirect" then
				local indexer = index.children[1].children[1].str
				local index_value = data[indexer]
				--print("accessing "..tostring(index_value).." of "..tostring(value))
				value = value[index_value]

			else-- index.children[1].name == "integer" then
				local index_name = index.children[1].str
				print("accessing "..index_name.." of "..tostring(value))
				value = value[tonumber(index.children[1].str)]
			end
		end
	end
	return value
end

eval.parentheses = function(tree, data)
	return eval.pre_evaluate(tree.children[1], data)
end


eval.list = function(tree, data)
	--print(tree)
	local list = List()
	for i, v in ipairs(tree.children[1].children) do
		table.insert(list, eval.pre_evaluate(v, data))
	end
	return list
end


return eval
