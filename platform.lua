

function createPlatform(world, x, y, image)
	local platform = {}
	local scalingX = love.graphics.getWidth() / 1920
	local scalingY = love.graphics.getHeight() / 1080
	platform.x = x * love.graphics.getWidth()
	platform.y = y * love.graphics.getHeight()
	platform.image = love.graphics.newImage(image)
	platform.width = platform.image:getWidth() * scalingX
	platform.height = platform.image:getHeight() * scalingY

	--For collision recognition
	platform.isPlatform = true

	world:add(platform, platform.x, platform.y, platform.width, platform.height)

	platform.draw = function ()
		love.graphics.setColor(BASE_COLOR)
		love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
		love.graphics.draw(platform.image, platform.x, platform.y, r, scalingX, scalingY)
	end

	return platform
end