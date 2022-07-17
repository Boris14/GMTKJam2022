--For delaying functions 
local tick = require("libraries.tick")

local background = {}

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
end

function love.load()
	love.window.setFullscreen(true)
	love.graphics.setDefaultFilter("nearest", "nearest")
	background[1] = love.graphics.newImage("assets/background/bg_layer1.png")
	background[2] = love.graphics.newImage("assets/background/bg_layer2.png")
	background[3] = love.graphics.newImage("assets/background/bg_layer3.png")
	background[4] = love.graphics.newImage("assets/background/bg_layer4.png")
	-- love.graphics.setBackgroundColor(BG_COLOR)
  	
	scaleConstants(love.graphics.getWidth(), love.graphics.getHeight())

  --Set the local values
  	game = createGame()
end

function love.update(dt)
	--tick.update(dt)
	game.update(dt)
end

function love.draw()
	for i,v in ipairs(background) do
		love.graphics.draw(background[i], 0, -700)		
	end

	game.draw()
end