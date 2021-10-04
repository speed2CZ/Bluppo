extends VBoxContainer

signal closed

var mode = "load"

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		close()
		get_tree().set_input_as_handled()
		get_parent().openPauseMenu()

func open(type):
	var savedGames = SaveLoad.getSavedGames()
	var buttons = get_children()

	# Set the title
	if type == "load":
		$Title.text = "LOAD GAME"
	else:
		$Title.text = "SAVE GAME"

	# Rename the buttons with the saved games
	for index in range(1, buttons.size()):
		var text = savedGames[index]
		text.erase(0, text.rfind("/") + 1)
		text.erase(text.length() - 5, 5)
		text.replace("_", " ")
		buttons[index].setText(text)

	visible = true
	mode = type
	get_children()[1].grab_focus()

func close():
	visible = false
	emit_signal("closed")

func _on_Button_pressed(index):
	if mode == "load":
		var bank = SaveLoad.getLevelInBank(index)
		if bank:
			close()
			get_parent().loadLevel(bank["level"])
			PlayerData.onLoad(bank["lives"])
	else:
		close()
		SaveLoad.saveGame(index)
