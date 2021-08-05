
local eval = {}


local indirect_var_access = function(tree, data)
	local var_name = tree.children[1].str
	local access = {data, var_name}

	if tree:get("indexes") then
		for i, index in ipairs(tree:get("indexes").children) do
			if index.children[1].name == "name" then
				local index_name = index.children[1].str
				--print("accessing "..index_name.." of "..tostring(value))
				access = {access[1][access[2]], index_name}
				--value = value[index_name]

			elseif index.children[1].name == "indirect" then
				local indexer = index.children[1].children[1].str
				local index_value = data[indexer]
				--print("accessing "..tostring(index_value).." of "..tostring(value))
				access = {access[1][access[2]], index_value}

			else-- index.children[1].name == "integer" then
				local index_name = index.children[1].str
				--print("accessing "..index_name.." of "..tostring(value))
				--value = value[tonumber(index.children[1].str)]
				access = {access[1][access[2]], tonumber(index.children[1].str)}
			end
		end
	end
	return access
end

eval.special_attr = function(tree, from, to)
	--print(tree)

	local acc_data = to
	local va_tree = tree.children[1]
	local value_tree = tree.children[2]
	if #tree.children == 3 then
		--print("GLOBAL ", tree.children[2])
		--print("global table:", data:__global())

		acc_data = to:__global()
		va_tree = tree.children[2]
		value_tree = tree.children[3]
	end

	local var_access = indirect_var_access(va_tree, acc_data)
	--print("storing")table.foreach(var_access, print)
	local value = eval.pre_evaluate(value_tree, from)
	var_access[1][var_access[2]] = value
	return true
end

eval.attr = function(tree, data)
	return eval.special_attr(tree, data, data)
end

eval.print = function(tree, data)
	local value = eval.pre_evaluate(tree.children[1], data)
	io.write(tostring(value))
	return true
end

eval.test = function(tree, data)
	local value = eval.evaluate(tree.children[1], data)
	return value
end

return eval
