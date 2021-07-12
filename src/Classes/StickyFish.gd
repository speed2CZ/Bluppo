extends AllFishes

class_name StickyFish

var sticksTo = []

func doSpecialAction():
	for obj in special:
		if obj and canStickTo(obj):
			if not doingScpecialAction:
				anim.play("action")
				doingScpecialAction = true
			return true
		# If it was sticked to a fish, wait one tick
	if doingScpecialAction:
		doingScpecialAction = false
		
		# TODO: Investigate exact behaviour.
		#bumped = true
		#currentDirection = Vector2.DOWN
		return true
	return false

func canStickTo(_obj):
	pass
