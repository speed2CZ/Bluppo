extends MovableObject

class_name Bubble

onready var anim = $AnimatedSprite
onready var visNotifier = $VisibilityNotifier2D

var ambient = false
var deadly = false
var destroyNextTick = false
var playCreatedSound = true
var type = "None"

# Playing the sound only if the bubble is on the screen.
# It can't be in the _ready function since VisibilityNotifier2D is_on_screen()
# returns true only after the first frame.
func _process(_delta):
	if playCreatedSound:
		playCreatedSound = false
		if visNotifier.is_on_screen():
			Game.playSound("Bubble" + type + "Created")
	
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
	destroyNextTick = true

	if visNotifier.is_on_screen():
		if ambient:
			Game.playSound("BubbleSmallBurst")
		else:
			Game.playSound("BubbleBigBurst")

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
