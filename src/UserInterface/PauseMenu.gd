extends VBoxContainer

signal closed

var gameSpeedLabels = {
	1: "BOORING..",
	2: "VERY SLOW",
	3: "SLOW",
	4: "SLEEPY",
	5: "NO RUSH",
	6: "MEDIUM",
	7: "RUSH",
	8: "FAST",
	9: "VERY FAST",
	10: "CRAZY!",
}

func _ready():
	var _x = Game.connect("newGameSpeed", self, "_on_Speed_Changed")
	_x = SoundManager.connect("newVolume", self, "_on_Volume_Changed")
	
	_on_Volume_Changed(int(Options.getOption("volume")))

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		$Exit.grab_focus()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_left"):
		var focusedButton = get_focus_owner()
		if focusedButton == $Volume:
			SoundManager.decreaseVolume()
		elif focusedButton == $Speed:
			decreaseSpeed()
	elif event.is_action_pressed("ui_right"):
		var focusedButton = get_focus_owner()
		if focusedButton == $Volume:
			SoundManager.increaseVoluem()
		elif focusedButton == $Speed:
			increaseSpeed()

func open():
	show()
	# Select first button
	get_children()[0].grab_focus()
	$Speed.setText(gameSpeedLabels[Game.get_game_speed()])

func close():
	emit_signal("closed")
	visible = false

func _on_Continue_pressed():
	close()

func _on_Restart_pressed():
	close()
	get_parent().restartLevel(true)

func _on_Load_pressed():
	openLoadMenu("load")

func _on_Save_pressed():
	openLoadMenu("save")

func openLoadMenu(mode):
	visible = false
	get_parent().get_node("LoadMenu").open(mode)

func _on_Music_pressed():
	SoundManager.toggleMusic()

func _on_Volume_pressed():
	# TODO: Save the current config.
	pass

# Update volume bar.
func _on_Volume_Changed(value):
	# Play the UI sound only if the pause menu is open.
	if visible:
		SoundManager.playSound("UI_Focus")

	$Volume/HBoxContainer/TextureProgress.value = value

func _on_Speed_pressed():
	# TODO: Save the current config.
	pass

func decreaseSpeed():
	Game.gameSpeed -= 1

func increaseSpeed():
	Game.gameSpeed += 1

# Updated the label of the game speed button.
func _on_Speed_Changed(value):
	if gameSpeedLabels.has(value):
		SoundManager.playSound("UI_Focus")
		$Speed.setText(gameSpeedLabels[value])

# Return to thee main menu
func _on_Exit_pressed():
	get_parent().close()
