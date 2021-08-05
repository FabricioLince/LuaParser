
local Patternrule = require "parser/pattern"
local Select = require "parser/select"
local Sequence = require "parser/sequence"
local Multiple = require "parser/multiple"
local Optional = require "parser/optional"
local discard = require "parser/discard"
local utils = require "utils"
local token = require "tokens"

local value = Select{
	token.real,
	token.integer,
	token.name,
	token.string
}
value.name = "value"

value:add_rule(
	Sequence("signed_value", {
		token.symbol({"+","-"}),
		value
	})
)


local multiplication = Sequence("multiplication", {
	value,
	Multiple("ops", 0,
		Sequence("mult_operation", {
			token.symbol({"*", "/", "%"}),
			value
		})
	)
})


local addition =
Sequence("addition", {
	multiplication,
	Multiple("ops", 0,
		Sequence("addition_op", {
			token.symbol({"+","-"}),
			multiplication
		})
	)
})

local comparation = Sequence("comparation", {
	addition,
	Optional("ops",
		Sequence("comparator", {
			token.symbol{">=", ">", "<=", "<", "=="},
			addition
		})
	)
})

local expression = Sequence("expression", {
	comparation,
	Multiple("ops", 0,
		Sequence("bool_op", {
			Select{
				token.reserved("and"),
				token.reserved("or"),
				token.symbol{"&", "|"},
			},
			comparation
		})
	)
})


value:add_rule(
	Sequence("parentheses", {
		Patternrule("%("),
		expression,
		Patternrule("%)"),
	})
)


value:add_rule(
	Sequence("list", {
		discard(token.symbol("{")),
		Multiple("items", 0,
			expression
		),
		discard(token.symbol("}"))
	})
)

return {
	expression = expression,
	value = value,
}
