local tick = require("libraries.tick")
local anim8 = require("libraries.anim8")

function CreateDice(world, x, y)
    local dice = {}
    dice.x = x * love.graphics.getWidth()
    dice.y = y * love.graphics.getHeight()

    dice.dx = 0
    dice.dy = 0

    dice.value = 1
    dice.isRolling = false
    dice.size = 64 * DICE_SCALE

    dice.shrinkScale = 1

    --Animation related
    dice.spriteSheet = love.graphics.newImage("assets/dice/diceWhiteSprite.png")
    dice.grid = anim8.newGrid(64, 64, dice.spriteSheet:getWidth(), dice.spriteSheet:getHeight())
    dice.animation = anim8.newAnimation(dice.grid('1-3', 1, '1-3', 2), 0.2)

    --Collision related
    dice.isDice = true
    world:add(dice, dice.x, dice.y, dice.size, dice.size)
    dice.filter = function (item, other)
        return "cross"
    end

    --Methods
    dice.getRandomDice = function ()
        return love.math.random(6)
    end

    dice.startRolling = function ()
        dice.isRolling = true --Dice animation activates
        tick.delay(function ()
            dice.isRolling = false --Dice animation stops
        end, 2)
        local number = dice.getRandomDice()
        dice.animation:gotoFrame(number)
        dice.value = number
        --For later NUMBERS
    end

    dice.pickUp = function (player)
        if dice.isPickedUpBy then
            dice.isPickedUpBy.hasDice = false
            dice.isPickedUpBy.speed = dice.isPickedUpBy.speed / DICE_MOVEMENT_SLOW
        end
        dice.isPickedUpBy = player
        dice.shrinkScale = DICE_SHRINK_SCALE
        player.speed = player.speed * DICE_MOVEMENT_SLOW
        player.hasDice = true
    end

    --Default functions    
    dice.update = function (dt)
        
        ---Movement if player has taken it
        if dice.isPickedUpBy then
            local actualX, actualY, cols, len = world:move(dice, dice.isPickedUpBy.x, dice.isPickedUpBy.y - 40, dice.filter)
            dice.x, dice.y = actualX, actualY
        end
    

        if dice.isRolling then
            dice.animation:update(dt)
        end
    end

    dice.draw = function ()
        dice.animation:draw(dice.spriteSheet, dice.x, dice.y, nil, DICE_SCALE * dice.shrinkScale)
    end

    return dice
end