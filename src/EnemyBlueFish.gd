# Enemy fish that eats player instantly.
extends HungryFish

func _ready():
	eatsInstantly = true
	turnsInto = "CollectableGreenFish"
	eatingSound = "EnemyBlueFishEating"

# eats at 10th tick, else resease at 11
func canEat(obj):
	if obj.is_in_group("Player") or obj.is_in_group("Potion"):
		return true
	return false
