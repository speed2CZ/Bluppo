# World objects that can't be destroyed
# e.g. slopped ground or any tile that should be slippery
extends AllObjects

func _ready():
	killable = false
