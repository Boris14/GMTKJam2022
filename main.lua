--For delaying functions 
local tick = require("libraries.tick")

--For collision detection
local bump = require("libraries.bump")

--For camera movement, rotation, etc.
local camera = require("libraries.camera")

--For vector math
local vector = require("libraries.vector")

--For animations
local anim8 = require("libraries.anim8")

require("dice")


local index = 1
local world = bump.newWorld()

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setBackgroundColor(BG_COLOR)
	CreateDice()
end

function love.update(dt)
	tick.update(dt)
	Dice.Update(dt)
end

function love.draw()
	Dice.Draw()
end