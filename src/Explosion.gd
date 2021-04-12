extends AllObjects

onready var animation = $AnimatedSprite

var tick = 1

func _ready():
	slipOff = false
	killable = false

func onTick():
	playExplosionAnimation()

func playExplosionAnimation():
	tick += 1
	
	if tick <= 5:
		animation.play("Explosion_" + str(tick))
	else:
		destroy()
		# Create an ambient bubble as the end of the explosion
		Game.spawnObject("objects", "BubbleSmall", position)
