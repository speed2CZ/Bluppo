extends MovableObject

class_name Bubble

onready var anim = $AnimatedSprite

var ambient = false
var deadly = false
var destroyNextTick = false

var burstSound = "None"
var createdSound = "None"

# Main funciton that tries to move objects one tile lower
# also handles collisions with other objects, based on objects parameters
func moveObject():
	if destroyNextTick:
		destroy()
		return

	var Above = Game.getObjectAtPosition(position + Vector2.UP * Game.gridSize)
	
	# Nothing above, float up
	if not Above:
		move(Vector2.UP)
	# Floating up and hit something
	else:
		burst()

func burst():
	anim.play("burst")
	if ambient:
		Game.playSound("BubbleSmallBurst")
	else:
		Game.playSound("BubbleBigBurst")
	destroyNextTick = true

func isDeadly():
	return deadly

# Move the object 
func move(dir, markAsUpdated := true):
	last_position = position
	position += dir * Game.gridSize
	if not ambient:
		Game.updatePosition(self, last_position, markAsUpdated)
	
func canBePushed(_dir) -> bool:
	return true
