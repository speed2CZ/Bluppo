# Objects that spawn a fish when they fall one tile down.
extends MovableObject

# List of all fishes that can be spawned.
export(String,
	"CollectableBlueFish",
	"CollectableGreenFish",
	"YellowFish",
	"BrownFish",
	"EnemyBlueFish",
	"FriendlyBlueFish",
	"FriendlyPurpleFish",
	"RedFish",
	"StaticFish") var spawns = "StaticFish"

func _ready():
	heavy = false
	if "Steel" in name:
		slipOff = false
	else:
		slipOff = true

func canBePushed(_dir):
	return false

func move(dir, markAsUpdated := true):
	last_position = position
	position += dir * Game.gridSize
	Game.updatePosition(self, last_position, markAsUpdated)
	# Create ambient bubbles if moving down
	if dir == Vector2.DOWN:
		Game.spawnObject("objects", "BubbleSmall", last_position)

	spawnFish()

func spawnFish():
	destroy()
	if spawns == "YellowFish" or spawns == "BrownFish" or spawns == "EnemyBlueFish":
		Game.playSound("BadPresent")
	
	Game.spawnObject("fishes", spawns, position)
	
