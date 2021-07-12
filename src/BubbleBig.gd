extends Bubble

func _ready():
	type = "Big"

# Big bubble can't be pushed and blocks the player
func canBePushed(_dir) -> bool:
	return false
