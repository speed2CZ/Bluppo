extends VBoxContainer

signal closed

var mode = "load"

func _ready():
	var savedGames = SaveLoad.getSavedGames()
	var buttons = get_children()
	for index in buttons.size():
		var text = savedGames[index+1]
		text.erase(0, text.rfind("/") + 1)
		text.erase(text.length() - 5, 5)
		text.replace("_", " ")
		buttons[index].setText(text)

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		close()
		get_tree().set_input_as_handled()
		get_parent().openPauseMenu()

func open(type):
	visible = true
	mode = type
	get_children()[0].grab_focus()

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
