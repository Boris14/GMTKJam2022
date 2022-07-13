local index = 1

function love.load()
	love.graphics.setBackgroundColor(BG_COLOR)
end

function love.update(dt)
	index = index + 1
	if index > 7 then
		index = 1
	end
	love.timer.sleep(1)
	love.graphics.setColor(PLAYER_COLORS[index])
end

function love.draw()
	love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, 100)
end