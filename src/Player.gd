extends AllObjects

onready var ray = $RayCast2D
onready var animation = $AnimatedSprite

var movedir = Vector2()
var dead = false
var outOfOxygen = false
var DEBUG = false
var throwingBomb = false
var id = 0 # Number taken from the node's name to distinguish Player 1 and 2

var directions = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN,
}

var last_position = Vector2()

func _ready():
	# Add tick function
	var _x = Game.connect("move_Player", self, "movePlayer")
	_x = PlayerData.connect("oxygen_count", self, "drownedCheck")
	
	# Get the player's ID from the node name
	id = name.to_int()
	if id == 0:
		push_error("Player object doesn't have number in the name.")
		name = name +"1"
		id = 1
	Game.Players.push_back(id)
	
	slipOff = false
	
	last_position = position

func onTick():
	movePlayer()

var UP = false
var DOWN = false
var LEFT = false
var RIGHT = false
var bomb = false

func _unhandled_input(event):
	# Up/down movement takes priority, disallow moving diagonally
	if event.is_action_pressed("Player%s_Up" % id):
		UP = true
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("Player%s_Down" % id):
		DOWN = true
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("Player%s_Left" % id):
		LEFT = true
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("Player%s_Right" % id):
		RIGHT = true
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("Player%s_Bomb" % id) and PlayerData.numBombs > 0:
		bomb = true
		get_tree().set_input_as_handled()

func movePlayer():
	if outOfOxygen:
		if not Game.getObjectAtPosition(position + Vector2.DOWN * Game.gridSize):
			move(Vector2.DOWN)
		return

	if throwingBomb:
		if Input.is_action_pressed("Player%s_Bomb" % id):
			return
		throwingBomb = false
	
	UP = UP or Input.is_action_pressed("Player%s_Up" % id)
	DOWN = DOWN or Input.is_action_pressed("Player%s_Down" % id)
	LEFT = (LEFT or Input.is_action_pressed("Player%s_Left" % id)) and not (UP or DOWN)
	RIGHT = (RIGHT or Input.is_action_pressed("Player%s_Right" % id)) and not (UP or DOWN)

	bomb = bomb or Input.is_action_pressed("Player%s_Bomb" % id) and PlayerData.numBombs > 0

	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = - int(UP) + int(DOWN)

	# Not moving
	if movedir.x == 0 && movedir.y == 0:
		movedir = Vector2.ZERO
		if bomb:
			animation.play("bomb")
		elif animation.get_animation() != "idle" or animation.get_animation() != "holding":
			var Above = Game.getObjectAtPosition(position + Vector2.UP * Game.gridSize)
			if Above and Above.is_in_group("Movable"):
				animation.play("holding")
			else:
				animation.play("idle")
	# Moving
	else:
		var target = Game.getObjectAtPosition(position + movedir * Game.gridSize)
		# Play proper animation based on movement direction
		if animation.get_animation() == "bomb" and not target:
			throwBomb(movedir)
			animation.play("idle")
		else:
			var animToPlay = "default"
			for dir in directions:
				if directions[dir] == movedir:
					animToPlay = dir

			# Nothing blocing out way, let's move
			if not target:
				animation.play(animToPlay)
				move(movedir)
			# Something we can collect
			elif target.is_in_group("Collectable"):
				# Eating animation only for fishes
				if target.is_in_group("Fish"):
					animToPlay = "eating"
				animation.play(animToPlay)
				# Limit the number of bombs that can be collected
				if target.is_in_group("Explosive") and PlayerData.numBombs == PlayerData.maxBombs:
					pass
				else:
					target.onCollectedByPlayer(id)
					move(movedir)
			# Something we can push
			elif target.is_in_group("Movable"):
				# Play the proper animation even if the object can't be moved
				animation.play(animToPlay)
				if target.canBePushed(movedir):
					# Kill the player if moved into a red bubble
					if target.is_in_group("Bubble") and target.isDeadly():
						target.destroy()
						move(movedir)
						playerExplode()
					else:
						Game.playSound("Pushed")
						target.move(movedir, false)
						move(movedir)
			elif target.is_in_group("Exit") and target.isOpen():
				target._on_body_entered(id)
				destroy()
			else:
				animation.play(animToPlay)
	
	UP = false
	DOWN = false
	LEFT = false
	RIGHT = false
	bomb = false

func move(dir):
	last_position = position
	position += dir * Game.gridSize
	#move_and_collide(movedir * gridSize)
	Game.updatePosition(self, last_position)
	# Create ambient bubbles if moving down
	if dir == Vector2.DOWN and not Game.getObjectAtPosition(last_position + Vector2.UP * Game.gridSize):
		Game.spawnObject("objects", "BubbleSmall", last_position)

# Using direction to calculate and spawn a bomb at correct positon
func throwBomb(dir):
	throwingBomb = true
	PlayerData.numBombs -= 1

	var pos = position + dir * Game.gridSize
	# If we're not playing the bomb above us, try to set the position of the bom on tile lower
	# to make it look like it was thrown
	if dir != Vector2.UP and Game.isPositionFree(pos + Vector2.DOWN * Game.gridSize):
		pos = pos + Vector2.DOWN * Game.gridSize
	Game.spawnObject("objects", "RealBomb", pos)

func getMoveDir():
	return movedir

# When killed by Medusa or Red Bubbles
func playerExplode():
	if DEBUG:
		return
	destroy()
	Game.playSound("Explosion")
	Game.spawnObject("objects", "Explosion", position)
	Game.playerDied()

func drownedCheck(playerId, value):
	if DEBUG:
		return
	if playerId == id and value == 0 and not outOfOxygen:
		outOfOxygen = true
		animation.play("drowned")
		Game.playSound("OutOfOxygen")
		Game.playerDied()
