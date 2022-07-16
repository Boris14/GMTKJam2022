
require("platform")

function createLevel(world, scale, levelTemplate)
	
	local level = {} 

	--Add the platforms
	for i, v in ipairs(levelTemplate) do
		level[i] = {}
		level[i] = createPlatform(world, scale, v.x, v.y, v.width, v.height)
	end

	--Methods
	level.draw = function ()
		for i, v in ipairs(level) do
			v.draw()
		end
	end

	return level
end