extends TextureRect

onready var fishCounter = $FishCount
onready var levelCounter = $LevelCount
onready var lifeCounter = $LifeCount
onready var bombGrid = $BombGrid
onready var player1O2 = $Player1O2
onready var player2O2 = $Player2O2
onready var gameSpeed = $GameSpeed

func _ready():
	var _x = PlayerData.connect("bomb_count", self, "setBombCounter")
	_x = PlayerData.connect("fish_count", self, "setFishCounter")
	_x = PlayerData.connect("life_count", self, "setLifeCounter")
	_x = PlayerData.connect("oxygen_count", self, "setOxygenCounter")
	_x = Game.connect("new_Game_Speed", self, "setGameSpeed")
	
	# Set the initial info
	setLifeCounter(PlayerData.lives)
	setBombCounter(0)
	setGameSpeed(Game.get_game_speed())

func reset():
	setBombCounter(0)
	# TODO: Don't hardcode this value
	for i in [1, 2]:
		setOxygenCounter(i, 520)

# Grid 2x4 bomb icons
func setBombCounter(value):
	var bombTextures = bombGrid.get_children()
	for i in bombTextures.size():
		if i < value:
			bombTextures[i].visible = true
		else:
			bombTextures[i].visible = false

func setFishCounter(value):
	fishCounter.text = "%03d" % value

func setLifeCounter(value):
	lifeCounter.text = "%02d" % value

func setOxygenCounter(id, val):
	if id == 1:
		player1O2.value = val
	else:
		player2O2.value = val

func setLevelCount(value):
	levelCounter.text = "%03d" % value

func setGameSpeed(val):
	gameSpeed.value = val

func togglePlayer2(value):
	player2O2.visible = value
