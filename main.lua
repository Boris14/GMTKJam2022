--For delaying functions 
local tick = require("libraries.tick")

require("game")
require("menu")

local game
local menu

function love.keypressed(key, scancode, isrepeat)
	if key == "escape" then
    	love.event.quit(0)
	end
	menu.handleKeyPressed(key)
	if menu.startGame then
    	game.handleKeyPressed(key)
    end
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
	POWERUP_SCALE = POWERUP_SCALE * (widthScale + heightScale) / 2
	TIMER_FONT_SIZE = TIMER_FONT_SIZE * (widthScale + heightScale) / 2
end

function love.load()
	local music = love.audio.newSource( 'assets/sounds/background_song.mp3', 'static' )
	music:setLooping( true ) --so it doesnt stop
	music:play()
	--love.window.setFullscreen(true)
	love.graphics.setDefaultFilter("nearest", "nearest")
	Font = love.graphics.newFont("assets/font/DiloWorld-mLJLv.ttf", 64)
	love.graphics.setFont(Font)	
	scaleConstants(love.graphics.getWidth(), love.graphics.getHeight())

  --Set the local values
	menu = createMenu()
	game = createGame()
end

function love.update(dt)
	-- tick.update(dt)
	if menu.startGame then
		game.update(dt)
	end
end

function love.draw()
	if menu.startGame then
		game.draw()
	else --not in-game
		menu.draw()
	end
end