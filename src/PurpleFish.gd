# Friendly fish that eats enemy fishes instantly.
extends HungryFish

func _ready():
	eatsInstantly = true
	eatingSound = "PurpleFishEating"

func canEat(obj):
	if obj.is_in_group("Fish") and obj.is_in_group("Enemy"):
		return true
	return false
