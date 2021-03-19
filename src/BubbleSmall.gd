extends Bubble

# This bubble can go thorugh objects and vice versa, so we don't keep in the in global array.
func _ready():
	ambient = true
	Game.playSound("BubbleSmallCreated")
	Game.releasePosition(position)

	var _x = Game.connect("tick", self, "moveObject")

# Only delete the node without touching the global array with objects
func destroy():
	queue_free()
