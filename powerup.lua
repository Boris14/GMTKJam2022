
function createPowerupPickup(world, x, y)
	local powerup = {}

	powerup.x = x * love.graphics.getWidth()
	powerup.y = y * love.graphics.getHeight()

	powerup.image = love.graphics.newImage("assets/powerups/powerup_empty.png")

	powerup.width = powerup.image:getWidth() * POWERUP_SCALE
	powerup.height = powerup.image:getHeight() * POWERUP_SCALE

	powerup.destroy = false

	powerup.isPowerup = true
	world:add(powerup, powerup.x, powerup.y, powerup.width, powerup.height)

	local actualX, actualY, cols, len = world:check(powerup, powerup.x, powerup.y)
	for i = 1, len do
		local other = cols[i].other
		if other.isPowerup then
			world:remove(powerup)
			powerup = nil
			return powerup
		end
	end
	
	powerup.tick = require("libraries.tick")

	--Animation
	powerup.images = {}
	powerup.images[1] = love.graphics.newImage("assets/powerups/powerup_bubble.png")
	powerup.images[2] = love.graphics.newImage("assets/powerups/powerup_bunny.png")
	powerup.images[3] = love.graphics.newImage("assets/powerups/powerup_jetpack.png")
	powerup.images[4] = love.graphics.newImage("assets/powerups/powerup_wings.png")
	powerup.frame = 1
	powerup.anim_speed = 0

	powerup.animUpdate = function ()
		if powerup.anim_speed == 12 then --set interval of frame change
			powerup.frame = love.math.random(4)
			powerup.anim_speed = 0 --reset the speed to so the interval begins again
		end
		if powerup.anim_speed < 12 then
			powerup.anim_speed = powerup.anim_speed + 1
		end
	end

	powerup.checkToRemove = function (world)
		return powerup.destroy and world:hasItem(powerup)
	end

	powerup.movement = function(player)
		player.speed = player.speed * POWERUP_MOVEMENT_UPGRADE
		powerup.tick.delay(function() player.speed = PLAYER_SPEED end, POWERUP_MOVEMENT_DURATION)
		powerup.destroy = true
	end

	powerup.update = function (dt)
		powerup.animUpdate()
	end

	powerup.draw = function ()
		if not powerup.destroy then
			-- love.graphics.draw(powerup.image, powerup.x, powerup.y, 0, POWERUP_SCALE)
			love.graphics.draw(powerup.images[powerup.frame],powerup.x, powerup.y, nil, POWERUP_SCALE)

		end

	end

	return powerup
end

function createPowerupPicker(player)
	local powerup = {}

	powerup.x = player.x + PLAYER_SIZE/2
	powerup.y = player.y - DICE_HOVER_DISTANCE * 1.5

	powerup.image = love.graphics.newImage("assets/powerups/powerup_empty.png")
	powerup.width = powerup.image:getWidth() * POWERUP_SCALE
	powerup.height = powerup.image:getHeight() * POWERUP_SCALE
	--Add animation for the picking of the powerup
	powerup.images = {}

	if player.powerups == 1 then
		powerup.images[1] = love.graphics.newImage("assets/powerups/powerup_jetpack.png")
		powerup.images[2] = love.graphics.newImage("assets/powerups/powerup_bubble.png")
		powerup.images[3] = love.graphics.newImage("assets/powerups/powerup_wings.png")
	else
		powerup.images[1] = love.graphics.newImage("assets/powerups/powerup_gold_jetpack.png")
		powerup.images[2] = love.graphics.newImage("assets/powerups/powerup_gold_bubble.png")
		powerup.images[3] = love.graphics.newImage("assets/powerups/powerup_gold_wings.png")
	end

	powerup.frame = 1
	powerup.anim_speed = 0

	powerup.tick = require("libraries.tick")

	powerup.update = function(x, y)
		powerup.x = x + PLAYER_SIZE/5
		powerup.y = y - DICE_HOVER_DISTANCE * 2
		if powerup.anim_speed == 4 then --set interval of frame change
			powerup.frame = love.math.random(3)
			powerup.anim_speed = 0 --reset the speed to so the interval begins again
		end
		if powerup.anim_speed < 4 then
			powerup.anim_speed = powerup.anim_speed + 1
		end
		if powerup.isChosen then
			powerup.frame = powerup.chosenFrame
		end
	end

	powerup.choose = function (frame)
		powerup.chosenFrame = frame
		powerup.isChosen = true
	end

	powerup.draw = function ()
		love.graphics.draw(powerup.images[powerup.frame], powerup.x, powerup.y, 0, POWERUP_SCALE)
	end

	powerup.movement = function (player)
		player.isBoosted = true
		player.speed = player.speed * POWERUP_MOVEMENT_UPGRADE
		powerup.tick.delay(function() 
			player.speed = PLAYER_SPEED 
			player.isBoosted = false
		end, POWERUP_MOVEMENT_DURATION)
	end

	powerup.isDestroyed = false
	powerup.isChosen = false

	return powerup
end


