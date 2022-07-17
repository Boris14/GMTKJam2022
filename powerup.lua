
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

	powerup.tick = require("libraries.tick")

	powerup.checkToRemove = function (world)
		return powerup.destroy and world:hasItem(powerup)
	end

	powerup.movement = function(player)
		player.speed = player.speed * POWERUP_MOVEMENT_UPGRADE
		powerup.tick.delay(function() player.speed = PLAYER_SPEED end, POWERUP_MOVEMENT_DURATION)
		powerup.destroy = true
	end

	powerup.draw = function ()
		if not powerup.destroy then
			love.graphics.draw(powerup.image, powerup.x, powerup.y, 0, POWERUP_SCALE)
		end
	end

	return powerup
end

function createPowerupPicker(player)
	local powerup = {}

	powerup.x = player.x
	powerup.y = player.y - DICE_HOVER_DISTANCE

	--Add animation for the picking of the powerup
		
end

function powerUp(player)

end