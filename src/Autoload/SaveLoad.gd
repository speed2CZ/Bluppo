# File that manages saving and loading data to/from disc.
#
# Saving / Loading a level
# Since the levels are small enough, we dont save the whole state of the game,
# but just a level name (with some small details like lives count, etc)
#
# Records
# All time records (total fishes collected, deaths, etc..) are saved
# in a separate file and loaded when the game boots up.
extends Node

# TODO: 2 sets of banks, one for singleplayer and one for mp.
var banks = {
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
}

func smth():
	var time = OS.get_time()
	var time_return = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
	var date = OS.get_date()
	var date_return = "%02d.%02d.%04d" % [date.day, date.month, date.year]
	print(time_return, date_return)

func _ready():
	var _x = Game.connect("load_Next_Level", self, "saveRecords")
	_x = Game.connect("restart_Level", self, "saveRecords")

func getSaveData():
	var entry = {
		"date": OS.get_date(),
		"time": OS.get_time(),
		"type": getGameType(),
		"level": Game.getCurrentLevel(),
		"preview": getPreview(),
		"lives": PlayerData.lives
	}
	return entry

func getGameType():
	if Game.getPlayerCount() != 1:
		return "multiplayer"
	return "singleplayer"

# Generates a preview for the current level.
# Not working, maybe for Bluppo 2.0...
func getPreview():
	if true:
		return false
	# Retrieve the captured Image using get_data()
	#var img = get_viewport().get_texture().get_data()
	var img = get_node("/root").get_texture().get_data()
	# Flip on the y axis
	img.flip_y()
	# Save the screenshot
	img.save_png("user://screenshot.png")
	return true

# Saves a file to a user folder.
func saveFile(name, data):
	var file = File.new()
	file.open("user://%s" % name, File.WRITE)
	file.store_line(to_json(data))
	file.close()

# Loads a file from user folder.
func loadFile(name):
	var file = File.new()
	if not file.file_exists("user://%s" % name):
		return
	
	var data
	file.open("user://%s" % name, File.READ)
	while file.get_position() < file.get_len():
		data = parse_json(file.get_line())
	
	file.close()
	return data

func saveGame(bank):
	banks[bank] = getSaveData()
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_var(banks)
	save_game.close()
	print("Game saved to bank: %d" % bank)

func loadGame(bank):
	print("Loading game from bank: %d" % bank)
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return

	save_game.open("user://savegame.save", File.READ)
	banks = save_game.get_var()
	#while save_game.get_position() < save_game.get_len():
	#	banks = parse_json(save_game.get_line())
	save_game.close()
	
	if banks[bank]:
		return banks[bank]["level"]
	else:
		return false
	
	#get_node("/root").get_node("Main").loadLevel(data["level"])

# Returns a list of saved games.
func getSavedGames():
	populateSavedData()

	var data = {}
	for index in banks:
		if banks[index]:
			data[index] = banks[index]["level"]
		else:
			data[index] = ""
	return data

# Loads the saved games.
func populateSavedData():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return

	var data
	save_game.open("user://savegame.save", File.READ)
	#while save_game.get_position() < save_game.get_len():
	#	data = parse_json(save_game.get_line())
	data = save_game.get_var()

	banks = data

	save_game.close()

# Return the level name in the given bank or false.
func getLevelInBank(bank):
	if banks[bank]:
		return banks[bank]
	return false

# Saves all time records.
func saveRecords():
	print("*DEBUG: SaveLoad: Saving records.")
	var data = PlayerData.getRecords()
	if data:
		saveFile("profile.save", data)

# Saves all time records. Called at the game start.
func loadRecords():
	print("*DEBUG: SaveLoad: Loading records.")
	var data = loadFile("profile.save")
	if data:
		PlayerData.setRecords(data)
