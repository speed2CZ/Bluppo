extends Control

onready var menu = $Menu
onready var animation = $AnimationPlayer
onready var transition = get_node_or_null("/root/Transition/AnimationPlayer")

func _ready():
	# Add the node that handles transition animations (fade in, fade out).
	#if not transition:
		#var node = load("res://scenes/screens/Transition.tscn").instance()
		#get_node("/root").add_child(node)
		#get_parent().call_deferred("add_child", node)
		#transition = node.get_node("AnimationPlayer")
	
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
	animation.play("fade_out")
	# Select the first button
	menu.get_children()[0].grab_focus()

	#SoundManager.playSound("Theme")

# Start single player game from level 1.
func startSinglePlayer():	
	startGame("res://scenes/levels/Level_001.tscn")

	#startGame("res://scenes/levels/Level_Test_001.tscn")
	#startGame("res://scenes/levels/Level_042.tscn")

# Start split screen game from level 1.
func startMultiplayer():
	startGame("res://scenes/levels/mp/Level_001.tscn")

# Display the instuctions screen, how to play the game, keybindings, etc.
func showInstructions():
	$Menu/InstructionsButton.release_focus()
	print("instructions")
	#visible = false

	var instructions = load("res://scenes/screens/Instructions.tscn").instance()
	add_child(instructions)
	instructions.connect("closed", self, "open")

# Closes the game.
func _on_ExitButton_pressed():
	Options.saveOptions()

	animation.play("fade_in")
	yield(animation, "animation_finished")

	get_tree().quit()

# Initialize ingame UI and load the provided level.
func startGame(level):
	# Stop the theme song
	SoundManager.stopSound("Theme")
	
	# Play transition animation
	animation.play("fade_in")
	yield(animation, "animation_finished")

	# Create the game UI
	var ui = load("res://scenes/screens/UserInterface.tscn").instance()
	get_node("/root").add_child(ui)
	
	# Load the level	
	ui.loadLevel(level)

	# Hide the main menu
	visible = false
