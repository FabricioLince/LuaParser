

local rule_to_string = require "parser/rule_base"
local Tree = require "parser/tree"

local _to_string = function(cp)
	return "CheckPoint:"
end

local execute_cp = function(rule, stream)
	error("CheckPoint needs to be child of Sequence")
end
local CheckPoint = function(msg)
	local rule = {type="CheckPoint",name = "", msg=msg, execute=execute_cp, discard=true}
	return setmetatable(rule, {
		__call = execute_cp,
		__tostring = _to_string,
	})
end

return CheckPoint
