--For delaying functions 
local tick = require("tick")

--For collision detection
local bump = require("bump")

--For camera movement, rotation, etc.
local camera = require("camera")

--For vector math
local vector = require("vector")



local index = 1
local world = bump.newWorld()

function love.load()
	love.graphics.setBackgroundColor(BG_COLOR)
	
	tick.recur(function () 
			index = index + 1
			if index > 7 then index = 1 end
		end, 1)
end

function love.update(dt)
	tick.update(dt)
	love.graphics.setColor(PLAYER_COLORS[index])
end

function love.draw()
	love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 100)
end