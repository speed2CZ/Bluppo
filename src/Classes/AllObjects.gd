# Parent file to the all objects in the game
#
# Default parameters and common functionality can be found here
extends KinematicBody2D

class_name AllObjects

var slipOff = true
var killable = true
var can_move = true

func _ready():
	Game.registerObject(self)
	
	# Change the animation speed to match the game speed
	var anim = get_node_or_null("AnimatedSprite")
	if anim:
		var _x = Game.connect("new_Game_Speed", self, "changeAnimSpeed")
		changeAnimSpeed(Game.gameSpeed)

func onTick():
	pass

# Changes the animation speed for the animated sprite
func changeAnimSpeed(value):
	var new = 1.0 + (0.1 * (value - 1))
	$AnimatedSprite.set_speed_scale(new)

# Should things slip off us
func isSlippery():
	return slipOff

func setSlippery(value):
	slipOff = value

func forceSlip():
	return false

func canBeKilled():
	return killable

func canMove():
	return can_move

func setMovable(value):
	can_move = value

func destroy():
	Game.releasePosition(position)
	queue_free()

func onCollectedByPlayer(_playerId):
	pass

# Kill things in 3x3 area
func explode():
	if not canBeKilled():
		return
	
	Game.playSound("Explosion")
	
	var explosionArea = [
		position + Vector2.LEFT * Game.gridSize,                    # left
		position + (Vector2.LEFT + Vector2.UP) * Game.gridSize,     # top left
		position + (Vector2.LEFT + Vector2.DOWN) * Game.gridSize,   # bottom left
		position + Vector2.RIGHT * Game.gridSize,                   # right
		position + (Vector2.RIGHT + Vector2.UP) * Game.gridSize,    # top right
		position + (Vector2.RIGHT + Vector2.DOWN) * Game.gridSize,  # bottom right
		position + Vector2.UP * Game.gridSize,                      # top
		position + Vector2.DOWN * Game.gridSize,                    # bottom
		position,                                                   # middle
	]

	for pos in explosionArea:
		var obj = Game.getObjectAtPosition(pos)
		# Something that can be killed
		if obj and obj.canBeKilled():
			if obj.is_in_group("Fish"):
				# Count killed fishes
				PlayerData.records["FishesKilled"] += 1
			elif obj.is_in_group("Player"):
				Game.playerDied()
			else:
				PlayerData.records["TilesDestroyed"] += 1

			obj.destroy()
			Game.spawnObject("objects", "Explosion", pos)

		# Empty tile, just spawn explosion
		elif not obj:
			Game.spawnObject("objects", "Explosion", pos)
