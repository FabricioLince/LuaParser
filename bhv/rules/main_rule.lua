
local Patternrule = require "parser/pattern"
local Select = require "parser/select"
local Sequence = require "parser/sequence"
local Multiple = require "parser/multiple"
local Optional = require "parser/optional"
local discard = require "parser/discard"
local CheckPoint = require "parser/CheckPoint"


local token = require "bhv/rules/tokens"
local cmds = require "bhv/rules/cmds"


local behaviour_def = Sequence("behaviour_def", {
	token.name,
	discard(token.symbol(":")),
	CheckPoint(),
	cmds.cmd
})

local main_rule = Sequence("main", {
	Multiple("behaviours", 0, behaviour_def),
	CheckPoint("main command expected"),
	cmds.cmd,
	CheckPoint("end of file expected"),
	token.eof,
})

return main_rule
