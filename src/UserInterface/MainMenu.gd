extends Control

onready var menu = $Menu
onready var transition = get_node_or_null("/root/Transition/AnimationPlayer")

func _ready():
	# Add the node that handles transition animations (fade in, fade out).
	if not transition:
		var node = load("res://scenes/screens/Transition.tscn").instance()
		get_parent().call_deferred("add_child", node)
		transition = node.get_node("AnimationPlayer")

	# Randomize out RNG
	randomize()

	open()

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		$Menu/ExitButton.grab_focus()
		get_tree().set_input_as_handled()

# Open the main menu, plays init animation and selects the first button.
func open():
	visible = true
	# Init animation
	transition.play("fade_out")
	# Select the first button
	menu.get_children()[0].grab_focus()

	SoundManager.playSound("Theme")
	
	# Disable two player mode for mobile devices (since it's a split screen...)
	if OS.has_touchscreen_ui_hint():
		$Menu/TwoPlayersButton.disabled = true
		$Menu/TwoPlayersButton.visible = false

# Start single player game from level 1.
func startSinglePlayer():
	startGame("res://scenes/levels/Level_001.tscn")

	#startGame("res://scenes/levels/new/Level_Test_009.tscn")
	#startGame("res://scenes/levels/new/Level_005.tscn")

# Start split screen game from level 1.
func startMultiplayer():
	startGame("res://scenes/levels/mp/Level_001.tscn")

# Display the instuctions screen, how to play the game, keybindings, etc.
func showInstructions():
	# Stop the theme song
	SoundManager.stopSound("Theme")

	# Play transition animation
	transition.play("fade_in")
	yield(transition, "animation_finished")

	$Menu/InstructionsButton.release_focus()

	var instructions = load("res://scenes/screens/Instructions.tscn").instance()
	add_child(instructions)
	instructions.connect("closed", self, "open")

# Display all time player stats.
func showStatistics():
	# Play transition animation
	transition.play("fade_in")
	yield(transition, "animation_finished")
	
	$Menu/StatisticsButton.release_focus()

	var statistics = load("res://scenes/screens/Statistics.tscn").instance()
	add_child(statistics)
	statistics.connect("closed", self, "open")

# Closes the game.
func _on_ExitButton_pressed():
	Options.saveOptions()

	transition.play("fade_in")
	yield(transition, "animation_finished")

	get_tree().quit()

# Initialize ingame UI and load the provided level.
func startGame(level):
	# Stop the theme song
	SoundManager.stopSound("Theme")
	
	# Play transition animation
	transition.play("fade_in")
	yield(transition, "animation_finished")

	# Create the game UI
	var ui = load("res://scenes/screens/UserInterface.tscn").instance()
	get_node("/root").add_child(ui)
	
	# Load the level	
	ui.loadLevel(level)
	PlayerData.onLoad(10)

	# Remove the main menu
	queue_free()

# Top secret chaety level select
func _on_LineEdit_text_entered(new_text):
	startGame("res://scenes/levels/"+ new_text +".tscn")

var levelSelectNum = 0
func _on_LevelSelectEnabler_gui_input(event):
	if levelSelectNum == 5:
		return

	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			levelSelectNum += 1

			if levelSelectNum == 5:
				$Menu/LevelSelect.visible = true
