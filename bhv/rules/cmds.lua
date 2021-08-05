

local Sequence = require "parser/sequence"
local Select = require "parser/select"
local Multiple = require "parser/multiple"
local Optional = require "parser/optional"
local discard = require "parser/discard"
local CheckPoint = require "parser/CheckPoint"
local token = require "bhv/rules/tokens"
local expr = require "bhv/rules/expression"
local expression = expr.expression
local var_access = require "bhv/rules/var_access"


local attr = Sequence("attr", {
	Optional("global", token.symbol{"$"}),
	var_access,
	discard(token.symbol{"="}),
	CheckPoint(),
	expression,
})

local test = Sequence("test", {
	discard(token.symbol{"?"}),
	CheckPoint(),
	expression
})

local print_cmd = Sequence("print", {
	discard(token.symbol{"@"}),
	CheckPoint(),
	expression
})

local behaviour_call = Sequence("behaviour_call", {
	token.name,
	Optional("args",
		Sequence("args", {
			discard(token.symbol("{")),
			CheckPoint(),
			Multiple("args", 0,	attr),
			discard(token.symbol("}")),
		})
	)
})
expr.value:add_rule(behaviour_call, 2)

local behaviour_call_explicit = Sequence("behaviour_call", {
	discard(token.symbol(":")),
	token.name,
	CheckPoint(),
	Optional("args",
		Sequence("args", {
			discard(token.symbol("{")),
			CheckPoint(),
			Multiple("args", 0,	attr),
			discard(token.symbol("}")),
		})
	)
})
expr.value:add_rule(behaviour_call_explicit, 2)

local cmd = Select{
	attr,
	test,
	print_cmd,
	behaviour_call,
}

local cmds = Multiple("cmds", 0, cmd)

local sequencer = Sequence("sequencer", {
	discard(token.symbol{"("}),
	CheckPoint(),
	cmds,
	CheckPoint(") expected"),
	discard(token.symbol{")"})
})
cmd:add_rule(sequencer)

local selector = Sequence("selector", {
	discard(token.symbol{"["}),
	CheckPoint(),
	cmds,
	CheckPoint("] expected"),
	discard(token.symbol{"]"})
})
cmd:add_rule(selector)

local repeat_until_true = Sequence("repeat_true", {
	discard(token.symbol("!")),
	CheckPoint(),
	cmd
})
cmd:add_rule(repeat_until_true)

local invert = Sequence("invert", {
	discard(token.symbol("~")),
	CheckPoint(),
	cmd
})
cmd:add_rule(invert)


cmd:add_rule(Sequence("return", {
	discard(token.symbol(":")),
	CheckPoint(),
	expression
}))


return {
	cmds = cmds,
	cmd = cmd,
	attr = attr,
}
