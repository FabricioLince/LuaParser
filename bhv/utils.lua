

-- faster but doesn't preserve order
local remove_if_unordered = function(tbl, pred)
	local i = 1
	while i <= #tbl do
		if pred(i, tbl[i]) then
			if i < #tbl then
				tbl[i] = tbl[#tbl]
			end
			table.remove(tbl, #tbl)
		else
			i= i+1
		end
	end
end
local remove_if = function(tbl, pred)
	local i = 1
	while i <= #tbl do
		if pred(i, tbl[i]) then
			table.remove(tbl, i)
		else
			i= i+1
		end
	end
end


local get_tokens = function(stream, token_types)
	local tokens = {}
	while stream:has_next() do
		local token
		for i, tt in ipairs(token_types) do
			--print("testing token type #", i)
			token = tt(stream)
			if token then
				break
			end
		end
		if token then
			--print("ok", token)
			table.insert(tokens, token)
		else
			print("didn't find tokens beyond", stream:sub(5))
			break
		end
	end
	return tokens
end

		-- TABLE --

function table.find(tbl, pred) -- find index, element of tbl satisfying pred(v)
	for i, v in ipairs(tbl) do
		if pred(v) then
			return i, v
		end
	end
	return nil
end

function table.has(tbl, item)
	for i, v in ipairs(tbl) do
		if v == item then
			return i, v
		end
	end
	return nil
end

 ---------------------------------

		-- STRING --

string.trim = function(str, patt)
	if not patt then patt = "%s*" end
	return (str:gsub("^"..patt.."(.-)"..patt.."$", "%1"))
end
string.findall = function(str, patt)
	local positions = {}
	local pos = 0
	while true do
		pos = str:find(patt, pos+1)
		if pos then
			table.insert(positions, pos)
		else
			break
		end
	end
	return positions
end
string.line_number = function(str, pos)
	local _, count = str:sub(1, pos):gsub("\n", "\n")
	return count+1
end
string.col_number = function(str, pos)
	local count = 1
	while pos>1 and str:sub(pos, pos) ~= "\n" do
		count = count+1
		pos = pos-1
	end
	return count
end

 ---------------------------------



local remove_empty_ops
remove_empty_ops = function(tree)
	if not tree.children then
		return
	end
	local i = 1
	while i <= #tree.children do
		local c = tree.children[i]
		if c.is_tree and c:is_empty() and
			table.has({"ops", "indexes", "global"}, c.name) then
			table.remove(tree.children, i)
		else
			remove_empty_ops(c)
			i = i+1
		end
	end
end
local move_up_only_children
move_up_only_children = function(tree)
	if tree.children then
		for i, c in ipairs(tree.children) do
			if c.children then
				move_up_only_children(c)
				if #c.children == 1 then
					--print(c.name.. " child of ".. tree.name.. " has only 1 child ".. c.children[1].name)
					if table.has({"expression", "comparation", "addition", "multiplication", "args", "expr"}, c.name) then
						tree.children[i] = c.children[1]
					end
				end

			end
		end
	end
end




return {
	remove_if = remove_if,
	get_tokens = get_tokens,
	remove_empty_ops = remove_empty_ops,
	move_up_only_children = move_up_only_children,
}
