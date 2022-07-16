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


local world = bump.newWorld()
local scale
local player1
local player2
local ground
local level
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
	--love.window.setFullscreen(true)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setBackgroundColor(BG_COLOR)
  	
	scaleConstants(love.graphics.getWidth(), love.graphics.getHeight())

  	--Set the local values
    player1 = createPlayer(world, .1, .7, CONTROLS_1, PLAYER_SPRITE_1)
	player2 = createPlayer(world, .1, .7, CONTROLS_2, PLAYER_SPRITE_2)
	ground = createPlatform(world, 0, .9, "assets/platforms/grass/ground_grass_broken.png")
	base1 = createBase(world, false)
	level = createLevel(world, LEVEL_1)
	dice = CreateDice(world, .2, .7)
end

function love.update(dt)
	tick.update(dt)
	dice.update(dt)
    player1.update(dt)
    player2.update(dt)
end

function love.draw()
	dice.draw()
    player1.draw()
    player2.draw()
	ground.draw()
	level.draw()
	base1.draw()
end