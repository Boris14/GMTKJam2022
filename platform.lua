

function createPlatform(world, x, y, width, height)
	local platform = {}
	platform.x = x * love.graphics.getWidth()
	platform.y = y * love.graphics.getHeight()
	platform.width = width * love.graphics.getWidth()
	platform.height = height * love.graphics.getHeight()

	--For collision recognition
	platform.isPlatform = true

	world:add(platform, platform.x, platform.y, platform.width, platform.height)

	platform.draw = function ()
		love.graphics.setColor(BASE_COLOR)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
	end

	return platform
end