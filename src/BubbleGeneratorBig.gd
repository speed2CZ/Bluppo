extends BubbleGenerator

func _ready():
	bubbleType = "Big"

# This bubble generator can't be pushed to the side by the players.
func canBePushed(_dir) -> bool:
	return false
