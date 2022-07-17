--For delaying functions 
local tick = require("libraries.tick")

require("game")

local game

function love.keypressed(key, scancode, isrepeat)
    game.handleKeyPressed(key)
end

function scaleConstants(screenWidth, screenHeight)
	local widthScale = screenWidth / 1000
	local heightScale = screenHeight / 1000

	MAX_GRAVITY = MAX_GRAVITY * heightScale
	PLAYER_SPEED = PLAYER_SPEED * widthScale
	PLAYER_JUMP_FORCE = PLAYER_JUMP_FORCE * heightScale
	PLAYER_SIZE = PLAYER_SIZE * (widthScale + heightScale) / 2
	DICE_SCALE = DICE_SCALE * (widthScale + heightScale) / 2
	DICE_ROLLING_ASCENT = DICE_ROLLING_ASCENT * heightScale
	DICE_HOVER_DISTANCE = DICE_HOVER_DISTANCE * heightScale
	DICE_SPAWN.y = DICE_SPAWN.y * heightScale
end

function love.load()
	love.window.setFullscreen(true)
	love.graphics.setDefaultFilter("nearest", "nearest")
	Font = love.graphics.newFont("assets/font/DiloWorld-mLJLv.ttf", 64)
	love.graphics.setFont(Font)	
	scaleConstants(love.graphics.getWidth(), love.graphics.getHeight())

  --Set the local values
  	game = createGame()
end

function love.update(dt)
	--tick.update(dt)
	game.update(dt)
end

function love.draw()
	game.draw()
end