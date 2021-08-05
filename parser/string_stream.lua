
local get = function(stream, pos)
	pos = pos or stream.pos
	return stream.str:sub(pos, pos)
end
local next = function(stream)
	local p = stream.pos
	stream.pos = stream.pos+1
	return stream:get(p)
end
local has_next = function(stream)
	return stream.pos <= stream.str:len()
end
local get_pattern = function(stream, pattern)
	local a, b = stream.str:find(pattern, stream.pos)
	if a then
		stream.pos = b+1
		return {str = stream.str:sub(a, b), start=a, end_=b}
	end
end
local sub = function(stream, length)
	return stream.str:sub(stream.pos, stream.pos+length)
end
local line_number = function(stream, pos)
	if not pos then pos = stream.pos end
	local _, count = stream.str:sub(1, pos):gsub("\n", "\n")
	return count+1
end
local col_number = function(stream, pos)
	if not pos then pos = stream.pos end
	local count = 1
	while pos>1 and stream.str:sub(pos, pos) ~= "\n" do
		if stream.str:sub(pos, pos) == "\t" then
			count = count+4
		else
			count = count+1
		end
		pos = pos-1
	end
	return count
end
local create_stream = function(str)
	return {
		str = str,
		pos = 1,
		get = get,
		next = next,
		has_next = has_next,
		get_pattern = get_pattern,
		sub = sub,
		line_number = line_number,
		col_number = col_number,
	}
end

return create_stream
