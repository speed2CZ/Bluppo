extends MovableObject

onready var animation = $AnimatedSprite

# TODO: find out the correct timing and the spread pattern
# Best guess from several observations:
# Spreads on tick that are multiple of 7, probably up to 35
# First pick seems to be random, but might not be
var spreadTicks = [7, 14, 21, 28, 35]
var spreadTick = randi() % spreadTicks.size()
var tick = 0

func _ready():
	slipOff = false
	heavy = false

func onTick():
	moveObject()
	spreadSideways()

# Spreads to the sides
func spreadSideways():
	tick += 1
	if tick == spreadTicks[spreadTick]:
		spreadTick += 1
		if spreadTick > spreadTicks.size() - 1:
			spreadTick = 0

		var Right = position + Vector2.RIGHT * Game.gridSize
		var Left = position + Vector2.LEFT * Game.gridSize
		if not Game.getObjectAtPosition(Right):
			Game.spawnObject("objects", "HeavyMud", Right)
			Game.playSound("HeavyMud")
		if not Game.getObjectAtPosition(Left):
			Game.spawnObject("objects", "HeavyMud", Left)
			Game.playSound("HeavyMud")

		tick = 0

func onCollectedByPlayer(_playerId):
	Game.playSound("SeaweedCollected")
	destroy()
