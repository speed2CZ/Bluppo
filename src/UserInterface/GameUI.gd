extends Node

onready var scene_tree = get_tree()
onready var viewport1 = $UserInterface/Views/ViewportContainer1/Viewport1
onready var viewport2 = $UserInterface/Views/ViewportContainer2/Viewport2
onready var camera1 = $UserInterface/Views/ViewportContainer1/Viewport1/Camera1
onready var camera2 = $UserInterface/Views/ViewportContainer2/Viewport2/Camera2
onready var levelStats = $UserInterface/LevelStats
onready var separation = $UserInterface/Views/MermaidSeparation
onready var background = $Background
onready var pauseTexture = $PauseTexture
onready var gameOverTexture = $GameOverTexture
onready var transition = get_node("/root/Transition/AnimationPlayer")
onready var pauseMenu = $PauseMenu
onready var loadMenu = $LoadMenu

var gameSession = false

var canStartGame = false
var gameStarted = false

var paused: = false setget set_paused

var bgTexture

func _ready():
	var _x = Game.connect("loadNextLevel", self, "loadNextLevel")
	_x = Game.connect("restartLevel", self, "restartLevel")
	_x = Game.connect("gameOver", self, "gameOver")
	_x = pauseMenu.connect("closed", self, "closePauseMenu")
	_x = loadMenu.connect("closed", self, "closePauseMenu")

func _unhandled_input(event):
	# Wait for the init animation
	if not canStartGame:
		return
	elif not gameStarted:
		startGame()

	if event.is_action_pressed("ui_pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()
	elif event.is_action_pressed("ui_restart"):
		restartLevel(true)
	elif event.is_action_pressed("ui_cancel"):
		openPauseMenu()
	elif event.is_action_pressed("game_increase_speed"):
		Game.gameSpeed += 1
	elif event.is_action_pressed("game_decrease_speed"):
		Game.gameSpeed -= 1
	elif event.is_action_pressed("game_reset_speed"):
		Game.gameSpeed = 6

# Figures out next level from the current one and load it.
# If there is no next level, switches back to the main menu.
func loadNextLevel():
	transition.play("fade_in_slow")
	yield(transition, "animation_finished")

	# Figure out the next level name from the current one
	var levelName = Game.getCurrentLevel()
	var levelNum = gameSession.name.to_int()
	levelNum += 1
	levelName.erase(levelName.length() - 8, 8)
	levelName = levelName + "%03d" % levelNum + ".tscn"

	PlayerData.lives += 1

	loadLevel(levelName)

# Load the level and resets all counters.
# Returns to main menu if the level doesn't exits.
# @param levelName - Path to the level to load.
func loadLevel(levelName):
	# Remove the current level
	if gameSession:
		gameSession.queue_free()
		gameSession.get_parent().remove_child(gameSession)
		gameSession = false

	# Try to load the new level, else back to main menu.
	if ResourceLoader.exists(levelName):
		print("*DEBUG: Loading level: " + levelName)
		var game = load(levelName).instance()
		viewport1.add_child(game)
		gameSession = game
		levelStats.setLevelCount(gameSession.name.to_int())
		Game.setCurrentLevel(levelName)

		# Reset the player data, bomb and oxygen counters
		PlayerData.reset()
		levelStats.reset()
		
		# Everything is loaded at this point, do whatever is needed before the game start.
		Game.levelLoaded()
		
		# Pick a new bg texture
		setBackground()

		canStartGame = false
		gameStarted = false

		setCameras()
		playInitAnimation()
	else:
		close()

# Restarts the current level.
# Also decreases players' lives count.
# @param instant - defaults to false, skip the fade in animation.
func restartLevel(instant:= false):
	if not instant:
		transition.play("fade_in_slow")
		yield(transition, "animation_finished")

	PlayerData.lives -= 1

	loadLevel(Game.getCurrentLevel())

# Set up targets for the cameras to follow and decide if to use splitscreen or not.
func setCameras():
	viewport2.world_2d = viewport1.world_2d
	camera1.target = viewport1.get_child(1).get_node_or_null("Player1")
	camera2.target = viewport1.get_child(1).get_node_or_null("Player2")
	var tilemap = viewport1.get_child(1).get_node_or_null("TileMap")
	for camera in [camera1, camera2]:
		camera.setUpCamera(tilemap)

	# Hide second player view and middle separation if there's only 1 player.
	var splitScreen = camera2.target or false
	viewport2.get_parent().visible = splitScreen
	separation.visible = splitScreen
	levelStats.togglePlayer2(splitScreen)

# Pause/unpause the game, display text over the screen when paused.
func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	pauseTexture.visible = value

# Opens the overlay with the pause menu and pauses the game.
func openPauseMenu():
	$UserInterface/Views.visible = false
	self.paused = true
	pauseMenu.open()
	scene_tree.set_input_as_handled()

func closePauseMenu():
	$UserInterface/Views.visible = true

# Sets the background, picked randomly each level
func setBackground():
	bgTexture = load("res://assets/world/bg_" + str(randi() % 4 + 1) + ".png")
	background.set_texture(bgTexture)

func getBackgroundTexture():
	return bgTexture

func playInitAnimation():
	# Pause the game, play the animation and wait for player input to unpause
	self.paused = true
	pauseTexture.visible = false
	$GetReadyTexture.visible = true
	transition.play("fade_out_slow")
	yield(transition, "animation_finished")
	canStartGame = true

func playEndAnimation():
	transition.play("fade_in")
	yield(transition, "animation_finished")

func startGame():
	gameStarted = true
	self.paused = false
	$GetReadyTexture.visible = false

# Show game over texture and return to the main menu.
func gameOver():
	self.paused = true
	pauseTexture.visible = false
	$GameOverTexture.visible = true

	close(true)

# Fade the screen and return to the main menu.
func close(slow := false):
	# Slow transition used only with game over
	if slow:
		transition.play("fade_in_slow")
	else:
		transition.play("fade_in")
	yield(transition, "animation_finished")

	#get_node("/root").get_node("MainMenu").open()
	var mainMenu = load("res://scenes/screens/MainScreen.tscn").instance()
	get_node("/root").add_child(mainMenu)
	queue_free()
