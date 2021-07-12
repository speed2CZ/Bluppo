extends MovableObject

onready var animation = $AnimatedSprite
onready var visNotifier = $VisibilityNotifier2D

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
			spawnNewMud(Right)
		if not Game.getObjectAtPosition(Left):
			spawnNewMud(Left)

		tick = 0

func spawnNewMud(pos):
	if visNotifier.is_on_screen():
		Game.playSound("HeavyMud")
	Game.spawnObject("objects", "HeavyMud", pos)

func onCollectedByPlayer(_playerId):
	Game.playSound("SeaweedCollected")
	destroy()
