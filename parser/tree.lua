
local add_child = function(tree, child)
	if tree.children == nil then
		tree.children = {child}
	else
		table.insert(tree.children, child)
	end
end
local is_empty = function(tree)
	return not tree.children or #tree.children == 0
end

local get = function(tree, path)
	for i, c in ipairs(tree.children) do
		if c.name == path then
			return c
		end
	end
end

local ntab = 0
local ptab = function()
	local s = ""
	for i=1, (ntab-1) do s = s.."|  " end
	if ntab>0 then
		return s.."> "
	end
	return s
end
local tree_str
tree_str = function(tree)
	local s = tree.name
	if tree:is_empty() then
		s = s .. " [empty]"
	else
		ntab = ntab+1
		for i, c in ipairs(tree.children) do
			s = s .. "\n" .. ptab() .. tostring(c)
		end
		ntab = ntab-1
	end
	return s
end
local tree_metatable = {
	__tostring = tree_str
}
local Tree = function(name, children)
	return setmetatable(
	{
		name = name,
		children = children or {},
		add_child = add_child,
		is_empty = is_empty,
		is_tree = true,
		get = get,
	}, tree_metatable)
end

return Tree
