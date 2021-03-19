# Enemy fish that laughs before eating it's target.
extends HungryFish

func _ready():
	turnsInto = "CollectableBlueFish"
	eatingSound = "BrownFishEating"
	prepareSound = "BrownFishActive"

func canEat(obj):
	if (obj.is_in_group("Fish") and obj.is_in_group("Collectable")) or obj.is_in_group("Player") or obj.is_in_group("Potion"):
		return true
	return false
