function createMenu()
    local menu = {}
    menu.startGame = false

    menu.background = {}
	menu.background[1] = love.graphics.newImage("assets/background/bg_layer1.png")
	menu.background[2] = love.graphics.newImage("assets/background/bg_layer2.png")
	menu.background[3] = love.graphics.newImage("assets/background/bg_layer3.png")
	menu.background[4] = love.graphics.newImage("assets/background/bg_layer4.png")


    menu.handleKeyPressed = function (key)
        if key == START_GAME then
            menu.startGame = true
        end
        
    end

    menu.draw = function ()
		for i,v in ipairs(menu.background) do
			love.graphics.draw(menu.background[i], 0, -700)
		end
        love.graphics.print("This is the menu. Press SPACE to play", 0.1 * love.graphics.getWidth(), 0.3 * love.graphics.getHeight())
    end

    return menu

end
