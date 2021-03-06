require("powerup")


function createPlayer(world, x, y, controls, sprite)

	local player = {}

	--Location
	player.x = x * love.graphics.getWidth()
	player.y = y * love.graphics.getHeight()

	--Acceleration
	player.dx = 0
	player.dy = MAX_GRAVITY

	--Properties
	player.size = PLAYER_SIZE
	player.scale = PLAYER_SIZE / 186
	player.speed = PLAYER_SPEED

	--Controls
	player.jump = controls.jump
	player.left = controls.left
	player.right = controls.right
	player.pickUp = controls.pickUp
	player.powerUp = controls.powerUp

	player.powerups = 0
	player.powerupPicker = {}
	player.powerupPicker.isDestroyed = true

	player.isOnGround = false
	player.isJumping = false
	player.isRolling = false
	player.dice = nil

	player.isActivatingPowerup = false
	player.isBoosted = false
	player.isFrozen = false
	player.hasBigJump = false
	player.freezeOther = false

	--For delaying functions
	player.tick = require("libraries.tick")

	--For collision
	player.isPlayer = true
	player.filter = function (item, other)
		if other.isPlatform and not other.owner then
			return "slide"
		end
		return "cross"
	end

	world:add(player, player.x + 5, player.y, player.size - 5, player.size) 

	player.jumpPressed = false
	player.pickUpPressed = false

	--Animation
	player.anim8 = require("libraries.anim8")

	player.spriteSheet = love.graphics.newImage(sprite)
	player.grid = player.anim8.newGrid(192, 256, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

	player.animations = {}
	player.animations.idle = player.anim8.newAnimation(player.grid(1, 1, 6, 3), 1)
    player.animations.right = player.anim8.newAnimation(player.grid('7-9', 3), 0.1)
    player.animations.up_right = player.anim8.newAnimation( player.grid(2, 1), 0.2)
	player.animations.down_right = player.anim8.newAnimation(player.grid(9, 2), 0.2)
	player.animations.left = player.animations.right:clone():flipH()
	player.animations.up_left = player.animations.up_right:clone():flipH()
	player.animations.down_left = player.animations.down_right:clone():flipH()
	player.animations.up = player.anim8.newAnimation(player.grid(9,1), 0.2)
	player.animations.down = player.anim8.newAnimation(player.grid(9,5), 0.2)
	player.animations.win = player.anim8.newAnimation(player.grid(5,3), 0.2)

    player.anim = player.animations.idle

	--Methods
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
		if player.isRolling then
			player.anim = player.animations.win
		end
	end

	player.handleKeyPressed = function (key)
		if key == player.jump then
			--Player wants to jump before he has hit the ground
			if not player.jumpPressed and not player.isOnGround then
				player.jumpPressed = true
				player.tick.delay(function() player.jumpPressed = false end, JUMP_PRESS_INTERVAL)

			elseif player.isOnGround then --Player jumps from the ground
				player.executeJump()
			end
		elseif key == player.pickUp then
			player.pickUpPressed = true
			player.tick.delay(function() player.pickUpPressed = false end, 0.1)
		elseif key == player.powerUp and player.powerups > 0 and not player.isActivatingPowerup then
			player.isActivatingPowerup = true
			player.powerupPicker = createPowerupPicker(player)
			player.tick.delay(function() 
				player.powerupPicker.isChosen = true
				local frame = player.powerupPicker.frame
				if frame == 3 then frame = math.random(2) end
				player.powerupPicker.choose(frame)
				if frame == 1 then -- speedup
					player.powerupPicker.movement(player)
				elseif frame == 2 then -- freeze
					player.freezeOther = true
				end
				player.tick.delay(function() 
					player.powerupPicker.isDestroyed = true 
					player.isActivatingPowerup = false
				end, POWERUP_PICK_DELAY)
				player.powerups = 0
			end, POWERUP_PICKER_TIME)
		end
	end

	player.executeJump = function ()
		player.dy = -PLAYER_JUMP_FORCE
		player.isJumping = true
		player.isOnGround = false
		player.jumpPressed = false
		jumpSound:play()
	end

	player.update = function (dt)
		player.tick.update(dt)
		player.anim:update(dt)
		if player.isFrozen then
			player.anim:pause() 
			return
		end
		if not player.isRolling then
			--Wrap around map
			if player.x + player.size/2 > love.graphics.getWidth() then
				player.x = 0
			elseif player.x < 0 then
				player.x = love.graphics.getWidth() - player.size/2
			end

			if world:hasItem(player) then
				world:update(player, player.x, player.y, player.size, player.size)
			end

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
			if world:hasItem(player) then
				local goalX, goalY = player.x + player.dx * dt, player.y + player.dy * dt
				local actualX, actualY, cols, len = world:move(player, goalX, goalY, player.filter)
		 		player.x, player.y = actualX, actualY

		 		local hitsPlatform = false
		 		for i = 1, len do
		 			local other = cols[i].other
		 			if other.isPowerup then
		 				if player.powerups >= 2 then goto continue end
		 				player.powerups = player.powerups + 1
		 				other.destroy = true
		 			elseif other.owner == player and player.dice then
		 				if not player.dice.isRolling then 
		 					player.dice.startRolling() 
		 					player.isRolling = true
		 				end
		 			elseif other.isPlatform then
		 				hitsPlatform = true
		 				--Player hits a roof
		 				if player.isJumping and cols[i].normal.y == 1 then
		 					player.dy = 0
		 					player.isJumping = false
		 				elseif player.dy > 0 and cols[i].normal.y == -1 and not other.owner then --Player hits the ground
		 					player.isOnGround = true
		 					playerisJumping = false
		 				end
		 			elseif other.isDice and player.pickUpPressed then
		 			    other.pickUp(player)      
		 			end
					::continue::
		 		end

		 		--Player falls from a platform
		 		if not hitsPlatform and not player.isJumping and player.isOnGround then
		 			player.tick.delay(function() player.isOnGround = false end, 0.1)
		 		end
	 		end
 		end
 		if player.powerupPicker.isDestroyed == false then
			player.powerupPicker.update(player.x, player.y)
		end
 		player.updateAnimation()
	end

	player.draw = function ()
		if not player.powerupPicker.isDestroyed then player.powerupPicker.draw() end
		player.anim:draw(player.spriteSheet, player.x, player.y, nil, player.scale, player.scale, 0, 64)
	end

	return player
end

