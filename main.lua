--For delaying functions 
local tick = require("libraries.tick")

--For collision detection
local bump = require("libraries.bump")

--For camera movement, rotation, etc.
local camera = require("libraries.camera")

--For vector math
local vector = require("libraries.vector")

require("dice")
require("player")
require("platform")
require("level")
require("base")

local background = {}
local world = bump.newWorld()
local scale
local player1
local player2
local level
local ground
local dice
local base1


function love.keypressed(key, scancode, isrepeat)
    if scancode == "escape" then
        love.event.quit(0)
    end
    if key == "space" then
        dice.startRolling()
    end
    player1.handleKeyPressed(key)
    player2.handleKeyPressed(key)

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
	level = createLevel(world, LEVEL_1)
  	player1 = createPlayer(world, 0.1, 0.7, CONTROLS_1, PLAYER_SPRITE_1)
	player2 = createPlayer(world, 0.2, 0.8, CONTROLS_2, PLAYER_SPRITE_2)
	ground = createLevel(world, GROUND)
	dice = CreateDice(world, 0.48, 0.1)
	base1 = createBase(world, true)

end

function love.update(dt)
	tick.update(dt)
	dice.update(dt)
    player1.update(dt)
    player2.update(dt)
end

function love.draw()
	for i,v in ipairs(background) do
		love.graphics.draw(background[i], 0, -700)		
	end
	level.draw()
	ground.draw()
	dice.draw()
    player1.draw()
    player2.draw()
end