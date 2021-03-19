extends AllObjects

onready var animOpen = $AnimatedSprite
var open = false

func _ready():
	var _x = PlayerData.connect("open_exit", self, "openExit")
	
	slipOff = false
	killable = false

func openExit():
	animOpen.play("open")
	Game.playSound("ExitOpen")
	open = true

func _on_body_entered(id):
	animOpen.play("full")
	Game.playSound("ExitFull")
	open = false
	PlayerData.numPlayersInExit += 1
	Game.Players[id-1] = false

func isOpen():
	return open
