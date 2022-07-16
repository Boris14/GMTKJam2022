function createPlayer(world, scale, controls)
	local player = {}

	--Location
	player.x = 100
	player.y = 500

	--Acceleration
	player.dx = 0
	player.dy = GRAVITY_FORCE

	--Properties
	player.size = PLAYER_SIZE * scale
	player.speed = PLAYER_SPEED * scale

	--Controls
	player.jump = controls.jump
	player.down = controls.down
	player.left = controls.left
	player.right = controls.right

	player.tick = require("tick")

	world:add(player, player.x, player.y, player.size, player.size) 

	player.jumpPressed = false

	--Methods
	player.handleKeyPressed = function (key)
		
		if key == player.jump then
			--Player wants to jump before he has hit the ground
			if not player.jumpPressed and not player.isOnGround then
				player.jumpPressed = true
				player.tick.delay(function() player.jumpPressed = false end, JUMP_PRESS_INTERVAL)

			elseif player.isOnGround then --Player jumps from the ground
				player.executeJump()
			end
		end
	end

	player.executeJump = function ()
		player.dy = -PLAYER_JUMP_FORCE
		player.isJumping = true
		player.isOnGround = false
		player.jumpPressed = false
	end

	player.update = function (dt)
		
		player.tick.update(dt)

		local movingLeft = love.keyboard.isDown(player.left)
		local movingRight = love.keyboard.isDown(player.right)
		player.isJumping = player.dy < 0
		player.isOnGround = player.dy >= GRAVITY_FORCE

		if (movingRight and movingLeft) or (not movingLeft and not movingRight) then
			player.dx = 0
		elseif movingRight then
			player.dx = player.speed
		else --Moving Left
			player.dx = -player.speed
		end

		if player.isJumping then
			player.dy = player.dy + GRAVITY_FORCE * dt
		elseif not player.isOnGround then
			player.dy = player.dy + GRAVITY_FORCE * FALL_MULTIPLIER * dt			
		end

		if player.jumpPressed and player.isOnGround then
			player.executeJump()
		end

		--Move the player and check collisions
		local goalX, goalY = player.x + player.dx * dt, player.y + player.dy * dt
		local actualX, actualY, cols, len = world:move(player, goalX, goalY)
 		player.x, player.y = actualX, actualY
 		for i = 1, len do
 			local other = cols[i].other
 			if other.isPlatform then
 				--Player hits a roof
 				if player.isJumping and cols[i].touch.y <= player.y then
 					player.dy = 0
 				else --Player hits the ground
 					player.isOnGround = true
 				end
 			end
 		end


	end

	player.draw = function ()
		love.graphics.setColor(PLAYER_COLORS[3])
		love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
	end

	return player
end

