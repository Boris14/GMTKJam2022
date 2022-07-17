--For collision detection
local bump = require("libraries.bump")

require("dice")
require("player")
require("platform")
require("level")
require("base")


function createGame()
	local game = {}

	love.graphics.setDefaultFilter("nearest", "nearest")
	game.timer = ROUND_TIME
	game.timerFont = love.graphics.newFont("assets/font/DiloWorld-mLJLv.ttf", 128)

	game.tick = require("libraries.tick")

	game.player1Score = 0
	game.player2Score = 0

	game.roundStart = function ()
		if game.ready then return end
		game.world = bump.newWorld()
		game.player1 = createPlayer(game.world, PLAYER_1_START.x, PLAYER_1_START.y, CONTROLS_1, PLAYER_SPRITE_1)
		game.player2 = createPlayer(game.world, PLAYER_2_START.x, PLAYER_2_START.y, CONTROLS_2, PLAYER_SPRITE_2)
		game.base1 = createBase(game.world, true, game.player1)
		game.base2 = createBase(game.world, false, game.player2)
		game.level = createLevel(game.world, LEVEL_1)
		game.ground = createLevel(game.world, GROUND)
		game.dice = CreateDice(game.world, .48, .1)
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
		game.world:remove(game.player1)
		game.world:remove(game.player2)
		game.world:remove(game.dice)
		game.level.remove(game.world)
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
		if key == "escape" then
      		love.event.quit(0)
	    end
	    game.player1.handleKeyPressed(key)
	    game.player2.handleKeyPressed(key)
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
		game.dice.update(dt)
    	game.player1.update(dt)
    	game.player2.update(dt)
		if game.timer <= 0 then game.stop() end
	end

	game.draw = function ()
		if not game.ready then return end
		for i,v in ipairs(game.background) do
			love.graphics.draw(game.background[i], 0, -700)		
		end
		--Scale position
		game.ground.draw()
		game.level.draw()
		game.base1.draw()
		game.base2.draw()
		game.dice.draw()
		game.player1.draw()
    	game.player2.draw()
    	if math.floor(math.fmod(game.timer, 60)) < 10 then
    		love.graphics.print(math.floor(game.timer/60) .. ":0" .. math.floor(math.fmod(game.timer, 60)), game.timerFont, 500, 100)
    	else
    		love.graphics.print(math.floor(game.timer/60) .. ":" .. math.floor(math.fmod(game.timer, 60)), game.timerFont, 500, 100)
    	end
	end

	return game
end