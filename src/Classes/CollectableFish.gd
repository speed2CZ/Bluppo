# Fishes that can be collected by the players.
extends AllFishes

class_name CollectableFish

func onCollectedByPlayer(_playerId):
	PlayerData.numFishes += 1
	Game.playSound("FishCollected")
	destroy()
