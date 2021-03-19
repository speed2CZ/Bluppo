extends StickyFish

# Sticks to Collectable fishes, player and potions
func canStickTo(obj):
	if (obj.is_in_group("Fish") and obj.is_in_group("Collectable")) or obj.is_in_group("Player") or obj.is_in_group("Potion"):
		return true
	return false
