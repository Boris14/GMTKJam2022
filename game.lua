--For collision detection
local bump = require("libraries.bump")

require("dice")
require("player")
require("platform")
require("level")
require("base")
require("powerup")
require("HUD")


function createGame()
	local game = {}

	jumpSound = love.audio.newSource( 'assets/sounds/footstep09.ogg', 'static' )
	diceShuffle = love.audio.newSource( 'assets/sounds/dieShuffle3.ogg', 'static' )
	love.graphics.setDefaultFilter("nearest", "nearest")
	game.timer = ROUND_TIME
	game.timerFont = love.graphics.newFont("assets/font/DiloWorld-mLJLv.ttf", TIMER_FONT_SIZE)

	game.tick = require("libraries.tick")

	game.player1Score = 0
	game.player2Score = 0
	game.winner = nil

	game.HUD = createHUD() 

	game.roundStart = function ()
		if game.ready then return end
		game.world = bump.newWorld()
		game.powerups = {}
		game.player1 = createPlayer(game.world, PLAYER_1_START.x, PLAYER_1_START.y, CONTROLS_1, PLAYER_SPRITE_1)
		game.player2 = createPlayer(game.world, PLAYER_2_START.x, PLAYER_2_START.y, CONTROLS_2, PLAYER_SPRITE_2)
		game.base1 = createBase(game.world, true, game.player1)
		game.base2 = createBase(game.world, false, game.player2)
		game.level = createLevel(game.world, LEVEL_1)
		game.ground = createLevel(game.world, GROUND)
		game.dice = CreateDice(game.world, DICE_SPAWN.x, DICE_SPAWN.y)
		game.powerupSpawner = game.tick.recur(function ()
			local i = love.math.random(11)
			local newPowerup = createPowerupPickup(game.world, POWER_UPS[i].x, POWER_UPS[i].y)
			if newPowerup then
				table.insert(game.powerups,newPowerup)
			end
		end, POWERUPS_SPAWN_INTERVAL)
		game.ready = true
		game.roundFinished = false
	end

	game.background = {}
	game.background[1] = love.graphics.newImage("assets/background/bg_layer1.png")
	game.background[2] = love.graphics.newImage("assets/background/bg_layer2.png")
	game.background[3] = love.graphics.newImage("assets/background/bg_layer3.png")
	game.background[4] = love.graphics.newImage("assets/background/bg_layer4.png")

	game.roundStart()

	game.stop = function ()
		if not game.ready then return end
		game.ready = false
		if game.powerupSpawner then
			game.powerupSpawner:stop()
			game.powerupSpawner = nil
		end
		game.world:remove(game.player1)
		game.world:remove(game.player2)
		game.world:remove(game.dice)
		game.level.remove(game.world)
		for i = 1, #game.powerups do
			if game.world:hasItem(game.powerups[i]) then
				game.world:remove(game.powerups[i])
			end
		end
		game.powerups = {}
		game.level = nil
		game.world = nil
		game.base1 = nil
		game.base2 = nil
		game.ground = nil
		game.dice = nil
		game.player1 = nil
		game.player2 = nil
	end

	game.newRound = function()
		game.stop()
		game.roundStart()
	end

	game.handleKeyPressed = function (key)
		if game.ready then
			game.player1.handleKeyPressed(key)
			game.player2.handleKeyPressed(key)
		end
		if not game.ready then
			if key == START_GAME then
				game.winner = nil
				game.roundStart()
			end
		end
	end

	game.gameOver = function ()
		if game.player1Score > game.player2Score then 
			game.winner = "Player 1"
		elseif game.player2Score > game.player1Score then
			 game.winner = "Player 2"
		elseif game.player1Score == game.player2Score then 
			game.winner = "Nobody"
		end
		game.stop()
		game.timer = ROUND_TIME
		game.player1Score = 0
		game.player2Score = 0
	end

	game.update = function(dt)
		game.tick.update(dt)
		if not game.ready then return end
		game.timer = game.timer - dt
		if game.dice.hasRolled and not game.roundFinished then
			game.roundFinished = true
			if game.dice.isPickedUpBy == game.player1 then
				game.player1Score = game.player1Score + game.dice.value
			elseif game.dice.isPickedUpBy == game.player2 then
				game.player2Score = game.player2Score + game.dice.value
			end
			game.tick.delay(function() 
				game.newRound()
			end, 2)
		end
		for i, v in ipairs(game.powerups) do
			if v.checkToRemove(game.world) then
				game.world:remove(v)
			end
		end
		game.dice.update(dt)
		for i, v in ipairs(game.powerups) do
			v.update(dt)
		end
		if game.player1.freezeOther then
			game.player2.isFrozen = true
			game.tick.delay(function() 
				game.player2.isFrozen = false 
				game.player1.freezeOther = false
			end, FREEZE_DURATION)
		elseif game.player2.freezeOther then
			game.player1.isFrozen = true
			game.tick.delay(function() 
				game.player1.isFrozen = false 
				game.player2.freezeOther = false
			end, FREEZE_DURATION)
		end
		game.player1.update(dt)
		game.player2.update(dt)
		game.HUD.update(game.player1Score, game.player2Score, game.player1.powerups, game.player2.powerups, game.timer, game.timerFont)
		if game.timer <= 0 then game.gameOver() end
	end

	game.draw = function ()
		if not game.ready then
			if game.winner ~= nil then
				for i,v in ipairs(game.background) do
					love.graphics.draw(game.background[i], 0, -700)		
				end
				love.graphics.setColor(PLAYER_COLORS[1])
				love.graphics.printf("The winner is " .. game.winner, 0.25 * love.graphics.getWidth(), 0.2 * love.graphics.getHeight(), love.graphics.getWidth()/2, "center")
        		love.graphics.printf("Press SPACE to play again", 0.35 * love.graphics.getWidth(), 0.6 * love.graphics.getHeight(), love.graphics.getWidth()/2, "center", 0, .5, .5)
				love.graphics.setColor(BASE_COLOR)
			end
			return
		end
		for i,v in ipairs(game.background) do
			love.graphics.draw(game.background[i], 0, -700)		
		end

		game.ground.draw()
		game.level.draw()
		game.base1.draw()
		game.base2.draw()
		game.dice.draw()
		for i, v in ipairs(game.powerups) do
			v.draw()
		end
		game.player1.draw()
    	game.player2.draw()
		game.HUD.draw()
	end

	return game
end