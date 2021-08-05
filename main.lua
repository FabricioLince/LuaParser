

local utils = require "bhv/utils"
local Datatable = require "bhv/Datatable"

local bhv = require "bhv/bhv"


local main = function()
	local code = [[
		fac:[(?n<2:1)(::fac{n=n-1}*n)]
		size:(i=0!(i=i+1~?list..i):(i-1))
		ip:(i=1!(i=i+1?n%i==0)?n==i)
		(
			i=2
			!(
				[(ip{n=i}@i@" é primo\n")?1]
				i=i+1
				?i>100
			)
			l = {1 2 3 4 5 6}
			i=1
			!~(
				?l..i
				@"factorial of "
				@l..i
				@" = "
				@:fac{n=l..i}
				@"\n"
				i=i+1
			)
			@l
		)
	]]

	local data = Datatable{}
	local tree = bhv.extract_tree(code)
	--print(tree)

	if tree then
		local result = bhv.evaluate(tree, data)
		print("\nresult:", result)
	end
end

main()


