extends AllObjects

class_name AllFishes

onready var anim = $AnimatedSprite

var directions = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}

var currentDirection = Vector2.DOWN #Vector2()
var Front = false
var Back = false
var Left = false
var BackLeft = false
var BackRight = false
var Right = false
var Following = false
var last_position = Vector2()
var special = [Front, Back, Left, Right]
var doingScpecialAction = false
var bumped = true
var stucked = false

func _ready():
	last_position = position

# Decide the initial direction from the surrounding tiles
func findOutInitialVector():
	currentDirection = Vector2.UP
	scanSurroundings()
	# Cuz of the initial vector, Front is Up, Back is Down
	# No need to sort cases where fish is stucked or surrounded from 3 sides.
	if Left and Front and Right and Back:
		pass
	elif Front and Back:
		currentDirection = Vector2.RIGHT
	elif Left and Right:
		currentDirection = Vector2.DOWN
	elif Front:
		currentDirection = Vector2.RIGHT
	elif Right:
		currentDirection = Vector2.DOWN
	elif Back:
		currentDirection = Vector2.LEFT
	elif Left:
		currentDirection = Vector2.UP
	else:
		currentDirection = Vector2.DOWN
	
	# Set the proper animation
	for dir in directions:
		if directions[dir] == currentDirection:
			anim.play(dir)

# Fishes move along other things in a direction so they have the objects they move along on their left side
# That means clockwise inside of closed space, anti clockwise around an object
# Each tick we update what things are next to the fish to decide where to move next
func moveFish():
	scanSurroundings()

	# If we can do special action like to eat another fish or stick to on object, do it
	if doSpecialAction():
		return
	
	# Enemy fishes freze for a tick if there's heavy falling object above them,
	# to make them slightly easier to kill.
	if is_in_group("Enemy"):
		var Above = Game.getObjectAtPosition(position + Vector2.UP * Game.gridSize)
		if Above and Above.is_in_group("Movable") and Above.heavy and Above.falling:
			return
	
	# If no special action was done, let!s try to move
	if stucked:
		# We're stucked, keeps the original vector we has before getting stucked or default one.
		# Pretty obvious, only one direction can become available, so move wherever possible.
		if not Left:
			stucked = false
			turnLeft()
		elif not Right:
			stucked = false
			turnRight()
		elif not Front:
			stucked = false
			goForward()
		elif not Back:
			stucked = false
			turnBack()
		return
	else:
		# If the fish wasnt stucked last tick, check if we didnt get stucked now
		if Left and Front and Right and Back:
			stucked = true
			if not anim.get_animation() == "stucked":
				anim.play("stucked")
			return

	#
	if not bumped and not Left and not BackLeft:
		bumped = true
	
	if not bumped:
		if Front:
			if Left and not Right:
				turnRight()
			elif Right and not Left:
				turnLeft()
			elif not Left and not Right:
				turnLeft()
			else:
				turnBack()
		else:
			if not Left:
				turnLeft()
			else:
				goForward()
	else:
		if Front:
			bumped = false
			if not Right:
				turnRight()
			elif not Back:
				turnBack()
			else:
				turnLeft()
		elif Left:
			bumped = false
			goForward()
		else:
			goForward()

# Used by other classes to do special thing like eat or stick to other fishes.
func doSpecialAction():
	pass

func goForward():
	move(currentDirection)

func turnLeft():
	move(Vector2(currentDirection.y, -currentDirection.x))

func turnRight():
	move(Vector2(-currentDirection.y, currentDirection.x))

func turnBack():
	move(currentDirection * -1)

# Updates the objects around the fish at this tick
func scanSurroundings():
	Front = Game.getObjectAtPosition(position + currentDirection * Game.gridSize)
	Back = Game.getObjectAtPosition(position - currentDirection * Game.gridSize)
	Left = Game.getObjectAtPosition(position + Vector2(currentDirection.y, -currentDirection.x) * Game.gridSize)
	Right = Game.getObjectAtPosition(position + Vector2(-currentDirection.y, currentDirection.x) * Game.gridSize)
	BackLeft = Game.getObjectAtPosition(position + (Vector2(currentDirection.y, -currentDirection.x) - currentDirection) * Game.gridSize)
	BackRight = Game.getObjectAtPosition(position + (Vector2(-currentDirection.y, currentDirection.x) - currentDirection) * Game.gridSize)
	special = [Front, Back, Left, Right]

func move(vector, eating := false):
	if eating:
		anim.play("eating")
	else:
		for dir in directions:
			if directions[dir] == vector:
				anim.play(dir)
	currentDirection = vector
	last_position = position
	position += vector * Game.gridSize
	Game.updatePosition(self, last_position)
