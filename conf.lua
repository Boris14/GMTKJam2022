SMALL_VALUE = 0.1

BG_COLOR = {1, 1, 1} --white

WHITE = {1, 1, 1}

BASE_COLOR = {1, 0.788, 0.235}


PLAYER_COLORS = {
    {1, 0.788, 0.235}, --yellow
    {0.251, 0.659, 0.769}, --blue
    {0.996, 0.443, 0.443}, --red
    {0.843, 0.537, 0.843}, --purple
    {0.623, 0.875, 0.804} --green
}

PLAYER_SIZE = 60
PLAYER_SPEED = 300
PLAYER_JUMP_FORCE = 1100
MAX_GRAVITY = 1200
DICE_SCALE = 0.9

PLAYER_1_START = {x = .05, y = .84}
PLAYER_2_START = {x = .9, y = .84}

BASE_WIDTH = 0.2
BASE_HEIGHT = 0.1
GROUND_LEVEL = 0.9
GROUND_HEIGHT = 0.1
FALL_MULTIPLIER = 4
JUMP_FRICTION_MULTIPLIER = 2 
JUMP_PRESS_INTERVAL = 0.25

DICE_SHRINK_SCALE = 0.8
DICE_MOVEMENT_SLOW = 0.8

CONTROLS_1 = {}
CONTROLS_1.jump = "w"
CONTROLS_1.left = "a"
CONTROLS_1.right = "d"
CONTROLS_1.pickUp = "t"

CONTROLS_2 = {}
CONTROLS_2.jump = "up"
CONTROLS_2.left = "left"
CONTROLS_2.right = "right"
CONTROLS_2.pickUp = "space"

PLAYER_SPRITE_1 = "assets/characters/character_male.png"
PLAYER_SPRITE_2 = "assets/characters/character_female.png"

LEVEL_1 = {{}, {}}
LEVEL_1[1].x = .5 -- * screenWidth
LEVEL_1[1].y = .75 -- * screenHeight
LEVEL_1[1].image = "assets/platforms/grass/ground_grass_broken.png"
LEVEL_1[1].scale = 1

LEVEL_1[2].x = .2 -- * screenWidth
LEVEL_1[2].y = .65 -- * screenHeight
LEVEL_1[2].image = "assets/platforms/grass/ground_grass_small_broken.png"
LEVEL_1[2].scale = 1

GROUND = {{},{},{}}
GROUND[1].x = -0.01
GROUND[1].y = 0.95
GROUND[1].image = "assets/platforms/grass/ground_grass.png" 
GROUND[1].scale = 2

GROUND[2].x = 0.35
GROUND[2].y = 0.95
GROUND[2].image = "assets/platforms/grass/ground_grass.png" 
GROUND[2].scale = 2

GROUND[3].x = 0.7
GROUND[3].y = 0.95
GROUND[3].image = "assets/platforms/grass/ground_grass.png" 
GROUND[3].scale = 2


