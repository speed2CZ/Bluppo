extends MovableObject

onready var animation = $AnimatedSprite

var rng = RandomNumberGenerator.new()
var spreadTick = 7
var tick = 0

func _ready():
	slipOff = false
	heavy = false
	
	rng.randomize()
	spreadTick = rng.randi_range(7, 40)

	# Add tick function
	var _x = Game.connect("tick", self, "spreadSideways")
	#playRandomizedAnimation()

# Spreads to the sides, tick at which it spread is randomized each time
func spreadSideways():
	tick += 1
	if tick == spreadTick: #TODO: find out the correct timing and the spread pattern
		var direction = false
		var Right = position + Vector2.RIGHT * Game.gridSize
		var Left = position + Vector2.LEFT * Game.gridSize
		if not Game.getObjectAtPosition(Right):
			direction = Right
		elif not Game.getObjectAtPosition(Left):
			direction = Left

		# If we have a direction, spawn a new mud and set the new timer
		if direction:
			Game.spawnObject("objects", "HeavyMud", direction)
			spreadTick = rng.randi_range(7, 40)

		tick = 0

func playRandomizedAnimation():
	var offset = rng.randi() % animation.get_sprite_frames().get_frame_count("default")
	animation.set_frame(offset)

func onCollectedByPlayer(_playerId):
	Game.playSound("SeaweedCollected")
	destroy()
	
