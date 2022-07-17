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
    dice.hasRolled = false
    dice.size = 64 * DICE_SCALE

    dice.shrinkScale = 1.2

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

    dice.destination = {}

    dice.startRolling = function ()
        if dice.hasRolled then return 0 end
        dice.isRolling = true --Dice animation activates
        dice.shrinkScale = 1.2
        dice.destination = {x = dice.x, y = dice.y - DICE_ROLLING_ASCENT}
        tick.delay(function ()
            dice.hasRolled = true
            dice.isRolling = false --Dice animation stops
        end, 4)
        local number = dice.getRandomDice()
        dice.animation:gotoFrame(number)
        dice.value = number
        --For later NUMBERS
    end

    dice.pickUp = function (player)
        if dice.isRolling then return end
        if dice.isPickedUpBy then
            dice.isPickedUpBy.dice = nil
            dice.isPickedUpBy.speed = dice.isPickedUpBy.speed / DICE_MOVEMENT_SLOW
        end
        dice.isPickedUpBy = player
        dice.shrinkScale = DICE_SHRINK_SCALE
        player.speed = player.speed * DICE_MOVEMENT_SLOW
        player.dice = dice
    end

    --Default functions    
    dice.update = function (dt)
        
        ---Movement if player has taken it
        if dice.isPickedUpBy then
            local goalX
            local goalY
            if dice.destination.x then
                goalX = dice.destination.x
                goalY = dice.destination.y
            else
                goalX = dice.isPickedUpBy.x
                goalY = dice.isPickedUpBy.y - DICE_HOVER_DISTANCE
            end
            local actualX, actualY, cols, len = world:move(dice, goalX, goalY, dice.filter)
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