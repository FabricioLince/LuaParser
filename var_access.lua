
local Select = require "parser/select"
local Sequence = require "parser/sequence"
local Multiple = require "parser/multiple"
local discard = require "parser/discard"
local token = require "tokens"
local expr = require "expression"

local var_access = Sequence("var_access", {
	token.name,
	Multiple("indexes", 0,
		Sequence("index", {
			discard(token.symbol{"."}),
			Select{
				token.name,
				token.integer,
				Sequence("expr", {
					discard(token.symbol("(")),
					expr.expression,
					discard(token.symbol(")")),
				}),
				Sequence("indirect", {
					discard(token.symbol{"."}),
					token.name
				})
			}
		})
	)
})

table.insert(expr.value.rules, 1, var_access)

return var_access
