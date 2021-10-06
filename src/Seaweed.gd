extends Collectable

func _ready():
	slipOff = false

func onCollectedByPlayer(_id):
	PlayerData.records["SeaWeedsCollected"] += 1
	.onCollectedByPlayer(_id)
