anim8 = require("libraries.anim8")

function createPlayer(world, controls)

	local player = {}

	--Animation
	player.spriteSheet = love.graphics.newImage('assets/characters/character_female.png')
	player.grid = anim8.newGrid(192, 256, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

	player.animations = {}
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

    player.updateAnimation = function()
   		 if player.isJumping then
			if player.movingRight then
				player.anim = player.animations.up_right
			elseif player.movingLeft then
				player.anim = player.animations.up_left
			else
				player.anim = player.animations.up
			end
		elseif not player.isOnGround then
		    if player.movingRight then
		    	player.anim = player.animations.down_right
		    elseif player.movingLeft then
		    	player.anim = player.animations.down_left
		    else
		    	player.anim = player.animations.down
		    end
		elseif player.movingRight then
			player.anim = player.animations.right
		elseif player.movingLeft then
			player.anim = player.animations.left
		else --Idle
			player.anim = player.animations.idle
		end

	end

	--Location
	player.x = 100
	player.y = 500

	--Acceleration
	player.dx = 0
	player.dy = MAX_GRAVITY

	--Properties
	player.size = PLAYER_SIZE
	player.speed = PLAYER_SPEED

	--Controls
	player.jump = controls.jump
	player.down = controls.down
	player.left = controls.left
	player.right = controls.right

	player.isOnGround = true
	player.isJumping = false

	player.tick = require("libraries.tick")

	player.filter = function (item, other)
		if other.isPlatform then 
			return "slide"
		else
			return "slide"
		end 
	end

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
		--player.updateAnimation()


		player.movingLeft = love.keyboard.isDown(player.left)
		player.movingRight = love.keyboard.isDown(player.right)
		player.isJumping = player.dy < 0

		if (player.movingRight and player.movingLeft) or (not player.movingLeft and not player.movingRight) then
			player.dx = 0
		elseif player.movingRight then
			player.dx = player.speed
		else --Moving Left
			player.dx = -player.speed
		end

		
		if player.isJumping then
			player.dy = player.dy + MAX_GRAVITY * dt * JUMP_FRICTION_MULTIPLIER
		elseif player.isOnGround then
			player.dy = 0
		elseif player.dy < MAX_GRAVITY then
			player.dy = player.dy + MAX_GRAVITY * FALL_MULTIPLIER * dt		
		end

		if player.jumpPressed and player.isOnGround then
			player.executeJump()
		end

		--Move the player and check collisions
		local goalX, goalY = player.x + player.dx * dt, player.y + player.dy * dt
		local actualX, actualY, cols, len = world:move(player, goalX, goalY, player.filter)
 		player.x, player.y = actualX, actualY

 		--Player falls from a platform
 		if len == 0 and not player.isJumping and player.isOnGround then
 			player.tick.delay(function() player.isOnGround = false end, 0.1)
 		end

 		for i = 1, len do
 			local other = cols[i].other
 			if other.isPlatform then
 				--Player hits a roof
 				if player.isJumping and cols[i].normal.y == 1 then
 					player.dy = 0
 				elseif player.dy > 0 and cols[i].normal.y == -1 then --Player hits the ground
 					player.isOnGround = true
 					playerisJumping = false
 				end
 			end
 		end


	end

	player.draw = function ()
		if player.isOnGround then
			love.graphics.print("Is on ground", 100, 100)
		end
		player.updateAnimation()
		player.anim:draw(player.spriteSheet, player.x, player.y, nil, 0.2, 0.2, 0, player.size)
	end

	return player
end

