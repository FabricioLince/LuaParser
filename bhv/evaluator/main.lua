
local eval = {}
local evaluate = function(tree, data)
	local f = eval[tree.name]
	if f then
		return f(tree, data)
	end
	print("<"..tree.name..">")
end
local load_evaluator = function(path)
	local eval2 = require(path)
	eval2.evaluate = evaluate
	for k, v in pairs(eval2) do
		eval[k] = v
	end
	for k, v in pairs(eval) do
		eval2[k] = v
	end
end
load_evaluator("bhv/evaluator/expression")
load_evaluator("bhv/evaluator/cmd")
load_evaluator("bhv/evaluator/control")
load_evaluator("bhv/evaluator/behaviour")

eval.main = function(tree, data)
	for i, b in ipairs(tree.children[1].children) do
		evaluate(b, data)
	end
	return evaluate(tree.children[2], data)
end

return eval
