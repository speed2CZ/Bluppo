# Bomb that can be collected by the players.
# There's a RealBomb object for a bomb thrown by the players.
extends MovableObject

func _ready():
	heavy = false

# Increase number of bombs collected
func onCollectedByPlayer(_playerId):
	PlayerData.numBombs += 1
	Game.playSound("BombCollected")
	destroy()

func canBePushed(_dir):
	return false
