extends Node

# Signals to notify UI about updated values.
signal fish_count(value)
signal open_exit
signal bomb_count(value)
signal oxygen_count(id, value)
signal life_count(value)
signal game_over

# Constants
const maxBombs = 8
const maxOxygen = 1800
const maxLives = 99

# All time records, populated at the game start
var records = {
	"BombsCollected": 0,
	"BombsUsed": 0,
	"Deaths": 0,
	"FishesCollected": 0,
	"FishesKilled": 0,
	"LevelsFinished": 0,
	"OxygenCollected": 0,
	"SeaWeedsCollected": 0,
	"TilesDestroyed": 0,
}

# Level variables
var numPlayers = 1
var numPlayersInExit = 0  setget set_playersInExit
var lives = 10            setget set_lives
var numFishes = 0         setget set_fishes
var numRequiredFishes = 0 setget set_requiredFishes
var numBombs = 0          setget set_Bombs, get_Bombs
var oxygen = [520, 520]

func _ready():
	SaveLoad.loadRecords()

# Data that get reset each level.
func reset():
	print("*DEBUG: Resetting player data.")
	numPlayersInExit = 0
	numFishes = 0
	numBombs = 0
	oxygen = [520, 520]
	numPlayers = Game.getPlayerCount()

# Triggered when player enters the Exit object.
# Finish the level if all players are in exits.
func set_playersInExit(value: int):
	numPlayersInExit = value
	#print("*DEBUG: PlayerData: numPlayersInExit set to: ", numPlayersInExit)
	if numPlayersInExit == numPlayers:
		records["LevelsFinished"] += 1
		Game.levelDone()

# Keeps track of players' lives.
# When increasing, add 1 life for each player.
# Decreasing always by 1 (restarting level, dying)
func set_lives(value: int):
	if value < lives:
		# Player died
		records["Deaths"] += 1
		# End the game if we go under 0 lives
		if lives < 0:
			emit_signal("game_over")
		else:
			lives = value
	else:
		lives = min(value + numPlayers - 1, maxLives)
	#print("*DEBUG: PlayerData: Lives set to: ", lives)
	emit_signal("life_count", lives)

# Updates the number of currently collected fishes in the level.
func set_fishes(value: int):
	numFishes = value
	records["FishesCollected"] += 1
	#print("*DEBUG: PlayerData: Fish collected, currently have: ", numFishes)
	# Displaying how many fishes to catch to get to the next level
	var fishLeft = numRequiredFishes - numFishes
	if fishLeft >= 0:
		emit_signal("fish_count", fishLeft)

	if fishLeft == 0:
		#print("Enough fishes to finish the level, opening exit")
		emit_signal("open_exit")

# Updates bomb count whenever player collects or uses a bomb.
# Notifies UI about the change.
func set_Bombs(value: int):
	if value < 0 or value > maxBombs:
		push_error("ERROR: PlayerData: Number of bombs went through the seafloor! (or searoof)")
		return

	if value < numBombs:
		#print("*DEBUG: PlayerData: Bomb used, currently have: ", value)
		records["BombsUsed"] += 1
	else:
		#print("*DEBUG: PlayerData: Bomb collected, currently have: ", value)
		records["BombsCollected"] += 1

	numBombs = value
	emit_signal("bomb_count", numBombs)

# Returns the number of bombs players have collected in the level.
func get_Bombs():
	#print("Asking for a bomb, have: ", numBombs)
	return numBombs

# Updates oxygen of all players, separatly.
# Called each tick from the main loop to reduce the count,
# and increase when player picks a oxygen item.
func set_Oxygen(id: int, value: int):
	oxygen[id - 1] = min(oxygen[id - 1] + value, maxOxygen)
	#print("Oxygen for player: %d changed to: %d" %[id, oxygen[id - 1]])
	emit_signal("oxygen_count", id, oxygen[id - 1])

# Sets the number of fishes players have to collect each level.
# Notifies UI to display the number.
func set_requiredFishes(value: int):
	if value < 1:
		value = 1
		push_warning("WARNING: PlayerData: Trying to set number of required fishes < 1, overriding to 1.")
	numRequiredFishes = value
	#print("*DEBUG: PlayerData: Num of required fishes for this level set to: ", numRequiredFishes)
	emit_signal("fish_count", numRequiredFishes)

# Returns a table with current all time records.
func getRecords():
	return records

# Populate the table of all time records from given data.
# Called at the game start.
func setRecords(data):
	for key in data.keys():
		if records.has(key):
			records[key] = data[key]

# Resets all time records, can't be undone.
func resetRecords():
	# TODO: Make warning!
	if true:
		return
	for key in records:
		records[key] = 0
	SaveLoad.saveRecords()
