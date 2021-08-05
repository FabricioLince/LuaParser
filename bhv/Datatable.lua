
local child_metatable = {
	__index = function(self, index)
		if index == "__parent" then
			return
		end
		if self.__parent then
			return self.__parent[index]
		end
	end,
	__newindex = function(self, index, value)
		if index == "__parent" then return end
		if self.__parent and self.__parent[index] then
			self.__parent[index] = value
		else
			rawset(self, index, value)
		end
	end
}

local make_child = function(parent)
	local child = {__parent=parent}
	setmetatable(child, child_metatable)
	return child
end

local get_global
get_global = function(tbl)
	local parent = tbl.__parent
	if parent then
		return get_global(parent)
	end
	return tbl
end

local Datatable = function(tbl, parent)
	tbl = tbl or {}
	tbl.__parent = parent
	tbl.__global = get_global
	if parent then
		tbl.__behaviours = make_child(parent.__behaviours)
	else
		tbl.__behaviours = tbl.__behaviours or {}
	end
	return setmetatable(tbl, child_metatable)
end

return Datatable
