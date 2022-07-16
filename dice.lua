local tick = require("libraries.tick")
local anim8= require("libraries.anim8")

function CreateDice()
    Dice = {}
    Dice.x = 200
    Dice.y = 300
    Dice.toggle = true
    Dice.spriteSheet = love.graphics.newImage("assets/dice/diceWhiteSprite.png")
    Dice.grid = anim8.newGrid(64, 64, Dice.spriteSheet:getWidth(), Dice.spriteSheet:getHeight())
    Dice.animation = anim8.newAnimation(Dice.grid('1-3', '1-2'), 0.2)
    Dice.Draw = function ()
        -- love.graphics.draw(Dice.image, Dice.x, Dice.y)
        Dice.animation:draw(Dice.spriteSheet, Dice.x, Dice.y, nil)
    end
    Dice.isRolling = false
    Dice.startRolling = function ()
        Dice.isRolling = true
        tick.delay(function ()
            Dice.isRolling = false
        end, 2)
    end
    Dice.Update = function (dt)
        if Dice.isRolling then
            Dice.animation:update(dt)
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "space" then
        Dice.startRolling()
    end
end