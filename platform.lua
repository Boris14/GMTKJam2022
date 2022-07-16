

function createPlatform(world, x, y, image)
	local platform = {}
	platform.x = x * love.graphics.getWidth()
	platform.y = y * love.graphics.getHeight()
	platform.image = love.graphics.newImage(image)
	platform.width = platform.image:getWidth()
	platform.height = platform.image:getHeight()

	--For collision recognition
	platform.isPlatform = true

	world:add(platform, platform.x, platform.y, platform.width, platform.height)

	platform.draw = function ()
		love.graphics.setColor(BASE_COLOR)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
		love.graphics.draw(platform.image, platform.x, platform.y)
	end

	return platform
end