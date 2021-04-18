# This file controls all music and sounds
# TODO: Missing - in-game music for the music mode (theme song is used for now)
#               - music for instructions screen
#               - sound for HeavyMud
extends Node

signal new_Volume(value)

# OG Bluppo had two modes for sounds. One where all effetcs would play in the game
# and second where only the music would play. Could do both, but sticking to the original.
var mode = "SFX"
var bank = {}
# Sounds that can start playing again even if not finished yet
var multiple = ["BombActive", "Explosion", "Pushed", "SeaweedCollected", "SlipOff"]
# key sound prevents value sound to play
var exclusive = {
	"BubbleBigBurst": "BubbleBigCreated",
	"BubbleRedBurst": "BubbleRedCreated",
	"BubbleSmallBurst": "BubbleSmallCreated",
	"UI_Focus": "UI_Accept",
}
# UI sounds that should always play no matter the mode
var uiSounds = ["UI_Accept", "UI_Focus", "Theme", "Music"]

# Add the sound bank done and load all available sound files
func _ready():
	var soundBank = load("res://scenes/SoundManager.tscn").instance()
	add_child(soundBank)
	#get_node("/root").call_deferred("add_child", sound)
	
	for child in soundBank.get_children():
		bank[child.name] = child
	
	var volume = Options.getOption("volume")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)

func playSound(sound):
	if mode == "MUSIC" and not uiSounds.has(sound):
		return

	if bank.has(sound):
		if exclusive.has(sound) and bank[exclusive[sound]].is_playing():
			return
		if multiple.has(sound) or not bank[sound].is_playing():
			bank[sound].play()
	else:
		push_warning("WARNING: Sound Manager: Trying to play sound: %s, that doesn't exist." % sound)

func stopSound(sound):
	if bank.has(sound):
		bank[sound].stop()
	else:
		push_warning("WARNING: Sound Manager: Trying to stop sound: %s, that doesn't exist." % sound)

func getSound(sound):
	if bank.has(sound):
		return bank[sound]
	return false

# Switches between sound effects and just playng a music.
func toggleMusic():
	if mode == "SFX":
		print("*DEBUG: SoundManager: Switching to MUSIC mode.")
		playSound("Theme") #Music
		mode = "MUSIC"
	else:
		print("*DEBUG: SoundManager: Switching to SFX mode.")
		stopSound("Theme") #Music
		mode = "SFX"

func decreaseVolume():
	#var current = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var current = int(Options.getOption("volume"))
	if current > -40:
		var new = current - 2
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new)
		#_on_Volume_Changed(new)
		Options.setOption("volume", new)
		emit_signal("new_Volume", new)

func increaseVoluem():
	#var current = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	var current = int(Options.getOption("volume"))
	if current < 0:
		var new = current + 2
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), new)
		#_on_Volume_Changed(new)
		Options.setOption("volume", new)
		emit_signal("new_Volume", new)
