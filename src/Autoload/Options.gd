extends Node

var options = {
	"musicMode": "MUSIC",
	"volume": 10,
	"speed": 6,
}

func _ready():
	loadOptions()

func loadOptions():
	print("*DEBUG: Options: Loading options from user file.")
	var data = SaveLoad.loadFile("options.save")
	if data:
		print("*DEBUG: Options: Options loaded.")
		options = data

func saveOptions():
	print("*DEBUG: SaveLoad: Saving options.")
	SaveLoad.saveFile("options.save", options)

func getOption(name):
	if options.has(name):
		#print("*DEBUG: Options: Asking for option: " + name + " with value: " + str(options[name]))
		return options[name]
	
	push_warning("*WARNING: Options: Trying to get invalid option: %s" % name)
	return null

func setOption(name, value):
	if options.has(name):
		#print("*DEBUG: Options: Setting option: " + name + " to value: " + str(value))
		options[name] = value
	else:
		push_warning("*WARNING: Options: Trying to set invalid option: %s" % name)

# Save the options when the game is closed from the system.
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		saveOptions()
		get_tree().quit()
