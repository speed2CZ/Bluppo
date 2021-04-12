# This file controls all objects that ca be moved, either by player or by "gravity" (no fishes)
#
# By default these objects will sink down
# and most of them can slip off from each other to the side
#

extends AllObjects

class_name MovableObject

var falling = false
var heavy = true
var last_position = position
var slipOffVectors = [Vector2.RIGHT, Vector2.LEFT]

func onTick():
	moveObject()

# Main funciton that tries to move objects one tile lower
# also handles collisions with other objects, based on objects parameters
func moveObject():
	if not can_move:
		return
	
	var Below = Game.getObjectAtPosition(position + Vector2.DOWN * Game.gridSize)
	
	# Nothing below, fall down
	if not Below:
		falling = true
		move(Vector2.DOWN)
	# Falling and hit something
	elif falling:
		# Collision with world, stop falling
		if Below.is_in_group("World") or not heavy:
			falling = false
			if heavy:
				Game.playSound("ImpactGround")
			slip(Below)
		elif Below.is_in_group("Bubble"):
			falling = false
			slip(Below)
		# Kaboom if we hit fish or explosives
		elif Below.is_in_group("Fish") or Below.is_in_group("Explosive") or Below.is_in_group("Player"):
			Below.explode()
	else:
		slip(Below)

# Move the object 
func move(dir, markAsUpdated := true):
	last_position = position
	position += dir * Game.gridSize
	Game.updatePosition(self, last_position, markAsUpdated)
	# Create ambient bubbles if moving down
	if dir == Vector2.DOWN:
		Game.spawnObject("objects", "BubbleSmall", last_position)

# Function that tries to slip objected off from each other
# thosee objects have to be set as slippery
# Tiles next to both, the object we're moving and object we're trying to slip off, has to be empty
# Slipping off to the right has priority 
func slip(Below):
	if not Below.isSlippery():
		return
	
	for vector in slipOffVectors:
		if Game.isPositionFree(position + vector * Game.gridSize) and (Game.isPositionFree(Below.position + vector * Game.gridSize) or (Below.forceSlip() and Below.getslipOffVector() == vector)):
			Game.playSound("SlipOff")
			move(vector)
			return

# Check if the player can push us to the side
func canBePushed(dir) -> bool:
	if (dir == Vector2.LEFT or dir == Vector2.RIGHT) and not Game.getObjectAtPosition(position + dir * Game.gridSize):
		return true
	return false

func isFalling():
	return falling
