# This is the main file that controls what object will move and when
#
#
# The goal is to have the same kind of movement as in the OG Bluppo game
# After several lifetimes of observingthe the phenomenon I started noticing
# some repeating patters, that could be described like this:
# 	Everything is in grid
# 	Things update in set intervals (no shit, sherlock...)
# 	Player moves first
#	Then things get updated tile by tile, from left to right, top to bottom
#
# 	The exact movement behaviour of objects is described in the individual classes
#
#	All objects are stored in a 2D array
#   Update happens from left to right, from top to bottom
extends Node

signal tick
signal movePlayer
signal loadNextLevel
signal restartLevel
signal newGameSpeed(value)

var gameSpeeds = {
	1: 5.0,
	2: 5.5,
	3: 6.0,
	4: 6.5,
	5: 7.0,
	6: 7.5,
	7: 8.0,
	8: 8.5,
	9: 9.0,
	10: 9.5,
}

# Game speed in ticks per second
var ticksPerSecond = 5.0
var gameSpeed = 1 setget set_game_speed, get_game_speed

var currentTick = 0
var timeStep = 1.0 / ticksPerSecond
var my_timer = timeStep

# Grid size in pixels, updated from the TileMap when the level is loaded
var gridSize = 32
var currentLevel = ""
var tileMap
var Players = []

# Main array with all objects in the game
var allObjects = []
# Keep track of updated objects from this tick
var updatedObjects = []
# Indexes of objects spawned during the game
var nameIndexes = {}

func _ready():
	set_game_speed(int(Options.getOption("speed")))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	my_timer -= delta
	if my_timer <= 0:
		my_timer = timeStep
		tick()

# Adjusts the game speed, if it's in the allowed range.
# Sends a signal to the UI to update the game speed counter.
# @param newSpeed - Index of the new game speed
func set_game_speed(newSpeed):
	# No change, abort
	if newSpeed == gameSpeed:
		return
	# Valid speed, change it.
	elif gameSpeeds.has(newSpeed):
		gameSpeed = newSpeed
		ticksPerSecond = gameSpeeds[newSpeed]
		timeStep = 1.0 / ticksPerSecond
		print("*DEBUG: Game: New game speed is: %d, aka %.01f ticks per sec." % [gameSpeed, ticksPerSecond])
		Options.setOption("speed", gameSpeed)
		emit_signal("newGameSpeed", gameSpeed)

# Returns current game speed
func get_game_speed():
	return gameSpeed

# TODO: use the godot timer instead of custom one.
func startGame():
	currentTick = 0
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(timeStep)
	timer.connect("timeout", self, "tick")
	timer.start()

func endGame():
	pass

# Resets the level variables to default values.
func reset():
	currentTick = 0
	allObjects = []
	Players = []
	updatedObjects = []
	nameIndexes = {}

# Called when all players reach their Exits. 
func levelDone():
	print("*DEBUG: Game: Level cleared. Loading next level.")
	emit_signal("loadNextLevel")

# Called when player is eaten by an enemy fish, killed by a medusa, an exposion
# or when runs out of O2.
func playerDied():
	print("*DEBUG: Game: Player died. Restarting current level.")
	emit_signal("restartLevel")

func tick():
	# TODO: reset ticks
	currentTick += 1
	#print("Tick: ", currentTick)

	emit_signal("tick")
	moveObjects()
	
	# Decrease players' oxygen
	for i in Players.size():
		if Players[i]:
			PlayerData.set_Oxygen(Players[i], -1)
	

# Returns current tick number
func getCurrectTick():
	return currentTick

# Create the main array, for tracking all objects, based on the TileMap dimensions.
func initWorldArray(node):
	# Clean up after the last level.
	reset()

	# Save the TileMap, used as parent for other objects. 
	tileMap = node
	gridSize = tileMap.get_cell_size().x
	print("*DEBUG: Initializing world array, grid size set to: %d" % gridSize)
	
	var rectangle = tileMap.get_used_rect()
	if rectangle:
		print("*DEBUG: World rectangle: ", rectangle)
		for y in rectangle.end.y:
			allObjects.push_back([])
			for x in rectangle.end.x:
				allObjects[y].push_back(false)
	else:
		push_error('*ERROR: Initialization failed. No TileMap found for this level!')

# Adds entires to the main array for every tilemap cell based on cell's position.
# These are walls and groun that doesn't need to be slippery.
func registerTileMap(object, position):
	#print("registerTileMap")
	allObjects[position.y / gridSize][position.x / gridSize] = object

# Adds the object to the main array based on it's position.
func registerObject(object):
	#print("Register object: " + object.name + " at location: ", object.position)
	allObjects[object.position.y / gridSize][object.position.x / gridSize] = object

# Set up the initial vectors for fishes once everything is loaded
func levelLoaded():
	for y in allObjects.size():
		for x in allObjects[y].size():
			var obj = allObjects[y][x]
			if obj and not updatedObjects.has(obj):
				if obj.is_in_group("Fish") and obj.canMove():
					obj.findOutInitialVector()

# Returns number of players in the game.
func getPlayerCount():
	return Players.size()

# Set current level path, for restarting.
func setCurrentLevel(levelName):
	currentLevel = levelName

# Returns path of the current level.
func getCurrentLevel():
	return currentLevel

# Update objects from top of the grip down and from left to right.
func moveObjects():
	updatedObjects = []

	# Players get to move first
	emit_signal("movePlayer")

	for y in allObjects.size():
		for x in allObjects[y].size():
			var obj = allObjects[y][x]
			if obj and not updatedObjects.has(obj) and obj.has_method("onTick"):
				obj.onTick()
			elif not obj:
				if (randi() % 2000) == 0:
					spawnObject("objects", "BubbleSmall", Vector2(x, y) * gridSize)

# Update the position in our main array
# @param markAsUpdated - Use false if player moved the object
func updatePosition(object, lastPos, markAsUpdated := true):
	if not object:
		push_error("*ERROR: Trying to update position for nul object!")
	#print("Updated posotion for: " + object.name + " old pos: ", lastPos, " new pos: ", object.position)
	allObjects[lastPos.y / gridSize][lastPos.x / gridSize] = false
	allObjects[object.position.y / gridSize][object.position.x / gridSize] = object
	if markAsUpdated:
		updatedObjects.push_back(object)

# Removes the object at given position from the main array.
func releasePosition(pos):
	allObjects[pos.y / gridSize][pos.x / gridSize] = false

# Checks if there's an object at given position.
func isPositionFree(pos):
	return not allObjects[pos.y / gridSize][pos.x / gridSize]

# Return the object at given position, or false.
func getObjectAtPosition(pos):
	return allObjects[pos.y / gridSize][pos.x / gridSize]

# Spawn a new object in the game.
func spawnObject(folder, objName, pos):
	var path = "res://scenes/%s/%s.tscn" % [folder, objName]
	if ResourceLoader.exists(path):
		var object = load(path).instance()
		object.set_name(objName + getNewIndex(objName))
		object.position = pos
		#call_deferred("add_child", object)
		tileMap.add_child(object)
	else:
		push_error("*ERROR: Spawning object: %s." % path)

func getNewIndex(objName):
	if not nameIndexes.has(objName):
		nameIndexes[objName] = 0

	nameIndexes[objName] += 1

	return str(nameIndexes[objName])

func playSound(sound):
	if SoundManager:
		SoundManager.playSound(sound)
