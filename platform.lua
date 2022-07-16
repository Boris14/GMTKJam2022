

function createPlatform(world, scale, x, y, width, height)
	local platform = {}
	platform.x = x
	platform.y = y
	platform.width = width * scale
	platform.height = height * scale

	--For collision recognition
	platform.isPlatform = true

	world:add(platform, platform.x, platform.y, platform.width, platform.height)

	platform.draw = function ()
		love.graphics.setColor(BASE_COLOR)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
	end

	return platform
end