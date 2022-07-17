require("platform")


function createBase(world, isRight, player)
	local base = {}
	base.platforms = {{},{},{}}
	if isRight then
		base.platforms[1] = createPlatform(world, 0.03, .92, "assets/platforms/bases/portal_orange.png", 1)
		base.platforms[1].owner = player
		base.platforms[2] = createPlatform(world, -0.02, .75, "assets/platforms/grass/ground_grass_90deg.png", .6)
		base.platforms[3] = createPlatform(world, 0, .75, "assets/platforms/grass/gouble_grass.png", .7)
	else
		base.platforms[1] = createPlatform(world, .85, .92, "assets/platforms/bases/portal_yellow.png", 1)
		base.platforms[1].owner = player
		base.platforms[2] = createPlatform(world, .99, .75, "assets/platforms/grass/ground_grass_270deg.png", .6)
		base.platforms[3] = createPlatform(world, .87, .75, "assets/platforms/grass/gouble_grass.png", .7)
	end

	base.draw = function ()
		for i,v in ipairs(base.platforms) do
			v.draw()
		end
	end

	return base
end

