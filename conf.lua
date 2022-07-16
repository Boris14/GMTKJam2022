SMALL_VALUE = 0.1

BG_COLOR = {1, 1, 1} --white

BASE_COLOR = {1, 0.788, 0.235}


PLAYER_COLORS = {
    {1, 0.788, 0.235}, --yellow
    {0.251, 0.659, 0.769}, --blue
    {0.996, 0.443, 0.443}, --red
    {0.843, 0.537, 0.843}, --purple
    {0.623, 0.875, 0.804} --green
}

PLAYER_SIZE = 50
PLAYER_SPEED = 300
PLAYER_JUMP_FORCE = 1100
MAX_GRAVITY = 1200
FALL_MULTIPLIER = 4
JUMP_FRICTION_MULTIPLIER = 2 
JUMP_PRESS_INTERVAL = 0.2

DICE_SCALE = 0.9

CONTROLS_1 = {}
CONTROLS_1.jump = "w"
CONTROLS_1.down = "s"
CONTROLS_1.left = "a"
CONTROLS_1.right = "d"

CONTROLS_2 = {}
CONTROLS_2.jump = "up"
CONTROLS_2.down = "down"
CONTROLS_2.left = "left"
CONTROLS_2.right = "right"

PLAYER_SPRITE_1 = "assets/characters/character_male.png"
PLAYER_SPRITE_2 = "assets/characters/character_female.png"


LEVEL_1 = {{}, {}}
LEVEL_1[1].x = .7 -- * screenWidth
LEVEL_1[1].y = .7 -- * screenHeight
LEVEL_1[1].width = .2
LEVEL_1[1].height = .05

LEVEL_1[2].x = .2 -- * screenWidth
LEVEL_1[2].y = .6 -- * screenHeight
LEVEL_1[2].width = .2
LEVEL_1[2].height = .05