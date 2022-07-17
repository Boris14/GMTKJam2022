--For collision detection
local bump = require("libraries.bump")

require("dice")
require("player")
require("platform")
require("level")
require("base")


function createGame()
	local game = {}
	--Timer
	love.graphics.setDefaultFilter("nearest", "nearest")
	game.timer = 120
	game.timerFont = love.graphics.newFont("assets/font/DiloWorld-mLJLv.ttf", 128)

	game.start = function ()
		if game.ready then return end
		game.world = bump.newWorld()
		game.player1 = createPlayer(game.world, PLAYER_1_START.x, PLAYER_1_START.y, CONTROLS_1, PLAYER_SPRITE_1)
		game.player2 = createPlayer(game.world, PLAYER_2_START.x, PLAYER_2_START.y, CONTROLS_2, PLAYER_SPRITE_2)
		game.base1 = createBase(game.world, true, game.player1)
		game.base2 = createBase(game.world, false, game.player2)
		game.level = createLevel(game.world, LEVEL_1)
		game.ground = createLevel(game.world, GROUND)
		game.dice = CreateDice(game.world, .2, .7)
		game.ready = true
	end

	game.start()

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
	end

	game.handleKeyPressed = function (key)
		if key == "escape" then
      		love.event.quit(0)
	    end
	    game.player1.handleKeyPressed(key)
	    game.player2.handleKeyPressed(key)
	end

	game.update = function(dt)
		if not game.ready then return end
		game.timer = game.timer - dt
		game.dice.update(dt)
    	game.player1.update(dt)
    	game.player2.update(dt)
		if game.timer <= 0 then game.stop() end
	end

	game.draw = function ()
		if not game.ready then return end
		game.ground.draw()
		game.level.draw()
		game.base1.draw()
		game.base2.draw()
		love.graphics.print(math.floor(game.timer/60) .. ":" .. math.floor(math.fmod(game.timer, 60)), game.timerFont, 500, 100)
		game.dice.draw()
		game.player1.draw()
    	game.player2.draw()
	end

	return game
end