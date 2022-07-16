anim8 = require("libraries.anim8")

function createPlayer(world, scale, controls)
	local player = {}

	--Animation
	player.spriteSheet = love.graphics.newImage('assets/characters/character_female.png')
	player.grid = anim8.newGrid(192, 256, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

	player.animations = {}
    -- player.animations.down = anim8.newAnimation( player.grid('1-4', 1), 0.2 )
    -- player.animations.left = anim8.newAnimation( player.grid('1-4', 2), 0.2 )
	player.animations.idle = anim8.newAnimation(player.grid(1, 1, 6, 3), 1)
    player.animations.right = anim8.newAnimation( player.grid('7-9', 3), 0.2)
    player.animations.up_right = anim8.newAnimation( player.grid(2, 1), 0.2)
	player.animations.down_right = anim8.newAnimation(player.grid(9, 2), 0.2)
	player.animations.left = player.animations.right:clone():flipH()
	player.animations.up_left = player.animations.up_right:clone():flipH()
	player.animations.down_left = player.animations.down_right:clone():flipH()
	player.animations.up = anim8.newAnimation(player.grid(9,1), 0.2)
	player.animations.down = anim8.newAnimation(player.grid(9,5), 0.2)

    player.anim = player.animations.idle

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

	player.tick = require("libraries.tick")

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
		player.anim:update(dt)


		local movingLeft = love.keyboard.isDown(player.left)
		local movingRight = love.keyboard.isDown(player.right)
		player.isJumping = player.dy < 0
		player.isOnGround = player.dy >= GRAVITY_FORCE

		if (movingRight and movingLeft) or (not movingLeft and not movingRight) then
			player.dx = 0
			player.anim = player.animations.idle
		elseif movingRight then
			player.dx = player.speed
			player.anim = player.animations.right
		else --Moving Left
			player.anim = player.animations.left
			player.dx = -player.speed
		end
		if player.isJumping and not (movingRight or movingLeft) then
			player.anim = player.animations.up
		elseif movingRight and player.isJumping then
			player.anim = player.animations.up_right
		elseif movingRight and not player.isOnGround then
			player.anim = player.animations.down_right
		elseif movingLeft and player.isJumping then
			player.anim = player.animations.up_left
		elseif movingLeft and not player.isOnGround then
			player.anim = player.animations.down_left
		elseif not player.isOnGround then
			player.anim = player.animations.down
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
		-- love.graphics.setColor(1,0,0, 0.7)
		-- love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
		player.anim:draw(player.spriteSheet, player.x, player.y, nil, 0.2, 0.2, 0, player.size)
	end

	return player
end

