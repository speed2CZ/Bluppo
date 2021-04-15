extends MovableObject

onready var animation = $AnimatedSprite

var tick = 1

func _ready():
	heavy = false

func onTick():
	if tick <=8:
		moveObject()
	playDetonateAnimation()

func playDetonateAnimation():
	if tick <= 7:
		animation.play("Explosion_" + str(tick))
		Game.playSound("BombActive")

	# Explode on tick 8, stop moving.
	if tick == 8:
		# Animation shows explosion already, let's play the sound as well.
		animation.play("Explosion_" + str(tick))
		Game.playSound("Explosion")
	# Now do the real explosion that kills 3x3 tiles.
	elif tick == 9:
		explode()

	tick += 1
