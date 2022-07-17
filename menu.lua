function createMenu()
    local menu = {}
    menu.startGame = false

    menu.background = {}
	menu.background[1] = love.graphics.newImage("assets/background/bg_layer1.png")
	menu.background[2] = love.graphics.newImage("assets/background/bg_layer2.png")
	menu.background[3] = love.graphics.newImage("assets/background/bg_layer3.png")
	menu.background[4] = love.graphics.newImage("assets/background/bg_layer4.png")


    menu.handleKeyPressed = function (key)
        if key == START_GAME and not menu.startGame then
            menu.startGame = true
        end
        
    end

    menu.draw = function ()
		for i,v in ipairs(menu.background) do
			love.graphics.draw(menu.background[i], 0, -700)
		end
        love.graphics.setColor(PLAYER_COLORS[1])
        love.graphics.printf("RUN FOR THE DICE", 0.25 * love.graphics.getWidth(), 0.2 * love.graphics.getHeight(), love.graphics.getWidth()/2, "center")
        love.graphics.printf("Player 1 controls: WASD - Move, T - Grab die, LShift - PowerUp", 0.1 * love.graphics.getWidth(), 0.4 * love.graphics.getHeight(), love.graphics.getWidth()/1.6, "left", 0, .5, .5)
        love.graphics.printf("Player 2 controls: Arrows - Move, Space - Grab die, RShift - PowerUp", 0.6 * love.graphics.getWidth(), 0.4 * love.graphics.getHeight(), love.graphics.getWidth()/1.5, "right", 0, .5, .5)
        love.graphics.printf("Press SPACE to play", 0.35 * love.graphics.getWidth(), 0.6 * love.graphics.getHeight(), love.graphics.getWidth()/2, "center", 0, .5, .5)
        love.graphics.setColor(BASE_COLOR)
    end

    return menu

end
