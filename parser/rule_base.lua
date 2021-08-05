
local ntab = 0
local ptab = function()
	local s = ""
	for i=1, (ntab-1) do s = s.."| " end
	if ntab>0 then return s.."L " end
	return s
end
local has_shown = {}
local rule_str
rule_str = function(rule)
	--table.foreach(rule, print)
	local s = rule.type
	if rule.name then
		s = tostring(rule.name)..":"..s
	end

	if ntab > 20 then return s.."..." end

	if ntab == 0 then
		has_shown = {}
	elseif has_shown[rule.name] then
		return s.."..."
	end

	has_shown[rule.name or ""] = true

	if rule.rules then
		ntab = ntab+1
		for i, r in ipairs(rule.rules) do
			s = s .. "\n" .. ptab() .. tostring(r)
		end
		ntab = ntab-1
	elseif rule.child then
		ntab = ntab+1
		s = s .. "\n" .. ptab() .. tostring(rule.child)
		ntab = ntab-1
	end

	return s
end

return rule_str
