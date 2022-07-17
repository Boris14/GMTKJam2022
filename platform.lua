

function createPlatform(world, x, y, image, scale)
	local platform = {}
	local scalingX = love.graphics.getWidth() / 1920
	local scalingY = love.graphics.getHeight() / 1080
	platform.x = x * love.graphics.getWidth()
	platform.y = y * love.graphics.getHeight()
	platform.image = love.graphics.newImage(image)
	platform.width = platform.image:getWidth() * scalingX * scale
	platform.height = platform.image:getHeight() * scalingY * scale
	platform.scale = scale

	--For collision recognition
	platform.isPlatform = true

	world:add(platform, platform.x, platform.y, platform.width, platform.height)

	platform.draw = function ()
		love.graphics.setColor(BASE_COLOR)
		--love.graphics.rectangle("fill", platform.x, platform.y, platform.width, platform.height)
		love.graphics.draw(platform.image, platform.x, platform.y, 0, scalingX * platform.scale, scalingY * platform.scale)
	end

	return platform
end