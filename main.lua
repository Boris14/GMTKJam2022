--For delaying functions 
local tick = require("tick")

--For collision detection
local bump = require("bump")

--For camera movement, rotation, etc.
local camera = require("camera")

--For vector math
local vector = require("vector")

require("player")
require("platform")
require("level")


local world = bump.newWorld()
local scale
local player
local ground
local level



function love.keypressed(key, scancode, isrepeat)
    if scancode == "escape" then
        love.event.quit(0)
    end

    player.handleKeyPressed(key)

end

function love.load()
	love.graphics.setBackgroundColor(BG_COLOR)

	--Set the local values
	scale =  (love.graphics.getWidth() + love.graphics.getHeight()) / 1000
	player = createPlayer(world, scale, CONTROLS_1)
	ground = createPlatform(world, scale, 0, 530, 1000, 50)
	level = createLevel(world, scale, LEVEL_1)

end

function love.update(dt)
	--tick.update(dt)
	player.update(dt)
end

function love.draw()
	player.draw()
	ground.draw()
	level.draw()
end


