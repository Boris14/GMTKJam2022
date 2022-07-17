
function createHUD() 
	local HUD = {}

	HUD.update = function(player1Score, player2Score, player1Powerups, player2Powerups, timer, timerFont)
		HUD.player1Score = player1Score
		HUD.player2Score = player2Score
		HUD.player1Powerups = player1Powerups
		HUD.player2Powerups = player2Powerups
		HUD.timer = timer
		HUD.timerFont = timerFont
	end

	HUD.draw = function ()		
		local player1PowerupPos = {x = (PLAYER1_POWERUP_POSITION.x - .06) * love.graphics.getWidth(), y = (TIMER_POSITION.y + 0.01) * love.graphics.getHeight()}
		local player2PowerupPos = {x = PLAYER2_POWERUP_POSITION.x * love.graphics.getWidth(), y = (TIMER_POSITION.y + 0.01) * love.graphics.getHeight()}
		if HUD.player1Powerups == 1 then
			local powerup_img = love.graphics.newImage("assets/powerups/powerup_empty.png")
			love.graphics.draw(powerup_img, player1PowerupPos.x, player1PowerupPos.y, 0, POWERUP_SCALE)
		elseif HUD.player1Powerups == 2 then
			local powerup_img = love.graphics.newImage("assets/powerups/powerup_gold.png")
			love.graphics.draw(powerup_img, player1PowerupPos.x, player1PowerupPos.y, 0, POWERUP_SCALE)
		end
		if HUD.player2Powerups == 1 then
			local powerup_img = love.graphics.newImage("assets/powerups/powerup_empty.png")
			love.graphics.draw(powerup_img, player2PowerupPos.x, player2PowerupPos.y, 0, POWERUP_SCALE)
		elseif HUD.player2Powerups == 2 then
			local powerup_img = love.graphics.newImage("assets/powerups/powerup_gold.png")
			love.graphics.draw(powerup_img, player2PowerupPos.x, player2PowerupPos.y, 0, POWERUP_SCALE)
		end

		love.graphics.setColor(PLAYER_COLORS[1])
    	if math.floor(math.fmod(HUD.timer, 60)) < 10 then
    		love.graphics.print(math.floor(HUD.timer/60) .. ":0" .. math.floor(math.fmod(HUD.timer, 60)), HUD.timerFont, TIMER_POSITION.x * love.graphics.getWidth(), TIMER_POSITION.y * love.graphics.getHeight())
    	else
    		love.graphics.print(math.floor(HUD.timer/60) .. ":" .. math.floor(math.fmod(HUD.timer, 60)), HUD.timerFont, TIMER_POSITION.x * love.graphics.getWidth(), TIMER_POSITION.y * love.graphics.getHeight())
    	end
		love.graphics.print(HUD.player1Score .. "", PLAYER1_SCORE_POSITION.x * love.graphics.getWidth(), TIMER_POSITION.y * love.graphics.getHeight())
		love.graphics.print(HUD.player2Score .. "", PLAYER2_SCORE_POSITION.x * love.graphics.getWidth(), TIMER_POSITION.y * love.graphics.getHeight())
		love.graphics.setColor(BASE_COLOR)
	end

	return HUD
end