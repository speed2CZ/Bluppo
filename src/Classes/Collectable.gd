# Objects that player can enter.
extends AllObjects

class_name Collectable

func onCollectedByPlayer(_playerId):
	Game.playSound("SeaweedCollected")
	destroy()
