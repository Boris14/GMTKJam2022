local tick = require("libraries.tick")
local anim8= require("libraries.anim8")

function CreateDice()
    Dice = {}
    Dice.x = 200
    Dice.y = 300
    Dice.value = 1
    Dice.isRolling = false

    --Animation related
    Dice.spriteSheet = love.graphics.newImage("assets/dice/diceWhiteSprite.png")
    Dice.grid = anim8.newGrid(64, 64, Dice.spriteSheet:getWidth(), Dice.spriteSheet:getHeight())
    Dice.animation = anim8.newAnimation(Dice.grid('1-3', '1-2'), 0.2)

    --Methods
    Dice.getRandomDice = function ()
        return love.math.random(6)
    end
    Dice.startRolling = function ()
        Dice.isRolling = true --Dice animation activates
        tick.delay(function ()
            Dice.isRolling = false --Dice animation stops
        end, 2)
        local number = Dice.getRandomDice()
        Dice.animation:gotoFrame(number)
        if number == 1 then --The frame in the spreadsheet does not correspond to the value
            Dice.value = 5
        elseif number == 2 then
            Dice.value = 3
        elseif number == 3 then
            Dice.value = 4
        elseif number == 4 then
            Dice.value = 6
        elseif number == 5 then
            Dice.value = 1
        elseif number == 6 then
            Dice.value = 2
        end
        print(Dice.value)
    end
    
    --Default functions
    Dice.Draw = function ()
        Dice.animation:draw(Dice.spriteSheet, Dice.x, Dice.y, nil)
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