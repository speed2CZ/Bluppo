# Friendly fish that laughs and then eats enemy fishes.
extends HungryFish

func _ready():
	eatsAtTick = 8
	eatingSound = "FriendlyBlueFishEating"
	prepareSound = "FriendlyBlueFishAction"

# eats at 8th tick, else resease at 9
func canEat(obj):
	if obj.is_in_group("Fish") and obj.is_in_group("Enemy"):
		return true
	return false
