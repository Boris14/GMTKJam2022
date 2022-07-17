
require("platform")

function createLevel(world, levelTemplate)
	
	local level = {} 

	--Add the platforms
	for i, v in ipairs(levelTemplate) do
		level[i] = {}
		level[i] = createPlatform(world, v.x, v.y, v.image)
	end
	-- level.background = {}
	-- level.background[2] = love.graphics.newImage("assets/background/bg_layer2.png")
	-- level.background[3] = love.graphics.newImage("assets/background/bg_layer3.png")
	-- level.background[4] = love.graphics.newImage("assets/background/bg_layer4.png")

	--Methods
	level.draw = function ()
		for i, v in ipairs(level) do
			v.draw()
		end
	end

	return level
end