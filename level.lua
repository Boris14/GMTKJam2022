
require("platform")

function createLevel(world, levelTemplate)
	
	local level = {} 

	--Add the platforms
	for i, v in ipairs(levelTemplate) do
		level[i] = {}
		level[i] = createPlatform(world, v.x, v.y, v.image, v.scale)
	end

	--Methods
	level.draw = function ()
		for i, v in ipairs(level) do
			v.draw()
		end
	end

	return level
end