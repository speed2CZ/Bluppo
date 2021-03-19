# Object that increases player's O2 when collected.
extends Collectable

func onCollectedByPlayer(playerId):
	PlayerData.set_Oxygen(playerId, 520)
	PlayerData.records["OxygenCollected"] += 1
	Game.playSound("OxygenCollected")
	destroy()
