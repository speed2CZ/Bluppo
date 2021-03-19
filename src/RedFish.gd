extends StickyFish

func canStickTo(obj):
	if obj.is_in_group("Fish") and obj.is_in_group("Enemy"):
		return true
	return false
