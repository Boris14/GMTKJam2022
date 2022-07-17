require("platform")

function createBase(world, player, isRight)
	local base = {}
	base.platforms = {{},{},{}}
	if isRight then
		base.platforms[1] = createPlatform(world, 0, GROUND_LEVEL, BASE_WIDTH, GROUND_HEIGHT)
		base.platforms[2] = createPlatform(world, 0, GROUND_LEVEL - BASE_HEIGHT, BASE_WIDTH / 4, BASE_HEIGHT)
		base.platforms[3] = createPlatform(world, 0, GROUND_LEVEL - BASE_HEIGHT, BASE_WIDTH, GROUND_HEIGHT)
	end

	base.draw = function ()
		for i,v in ipairs(base.platforms) do
			v.draw()
		end
	end

	return base
end

