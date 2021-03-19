extends Bubble

func _ready():
	Game.playSound("BubbleBigCreated")

# Big bubble can't be pushed and blocks the player
func canBePushed(_dir) -> bool:
	return false
