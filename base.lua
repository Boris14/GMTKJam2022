require("platform")


function createBase(world, isRight)
	local base = {}
	base.platforms = {{},{}}
	if isRight then
		base.platforms[1] = createPlatform(world, 0, GROUND_LEVEL, "assets/platforms/grass/ground_grass.png")
		base.platforms[2] = createPlatform(world, -0.03, .56, "assets/platforms/grass/ground_grass_90deg.png")
		base.platforms[3] = createPlatform(world, 0, .5, "assets/platforms/grass/ground_grass_180deg.png")
	else
		base.platforms[1] = createPlatform(world, .8, GROUND_LEVEL, "assets/platforms/grass/ground_grass.png")
		base.platforms[2] = createPlatform(world, .98, .56, "assets/platforms/grass/ground_grass_270deg.png")
		base.platforms[3] = createPlatform(world, .8, .5, "assets/platforms/grass/ground_grass_180deg.png")
	end

	base.draw = function ()
		for i,v in ipairs(base.platforms) do
			v.draw()
		end
	end

	return base
end

