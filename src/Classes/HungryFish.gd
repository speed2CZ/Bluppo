# Fishes that can eat other fishes.
extends AllFishes

class_name HungryFish

var eatsInstantly = false
var turnsInto = "None"
var eatingSound = "None"
var prepareSound = "None"

var eatsAtTick = 10
var tick = 0

# eats at 10th tick, else resease at 11
func laughAndThenEat():
	tick += 1

	if tick == 1:
		Game.playSound(prepareSound)

	if tick < eatsAtTick:
		return true
	else:
		# Recheck if we have anything to eat
		scanSurroundings()
		for obj in special:
			if obj and canEat(obj):
				eat(obj)
				return true

		# If there isnt anything to eat when the fix is ready to eat, wait one tick, by returning true
		doingScpecialAction = false
		if tick == eatsAtTick:
			return true

		# Nothing more to eat, return to moving
		return false

# Eats the target fish or potion.
func eat(obj):
	Game.playSound(eatingSound)

	# Spawn a collectable fish if we ate potion
	if obj.is_in_group("Potion"):
		var pos = obj.position
		obj.destroy()
		Game.spawnObject("fishes", turnsInto, pos)
		destroy()
	else:
		obj.destroy()
		move((obj.position - position) / Game.gridSize, true)
		if obj.is_in_group("Player"):
			Game.playerDied()

func doSpecialAction():
	if doingScpecialAction:
		return laughAndThenEat()
	for obj in special:
		if obj and canEat(obj):
			if eatsInstantly:
				eat(obj)
				return true
			else:
				if not doingScpecialAction:
					anim.play("action")
					doingScpecialAction = true
					tick = 0
				return laughAndThenEat()
	doingScpecialAction = false
	return false

func canEat(_obj):
	pass
