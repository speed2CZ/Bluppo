extends Bubble

func _ready():
	deadly = true
	Game.playSound("BubbleRedCreated")

func burst():
	anim.play("burst")
	Game.playSound("BubbleRedBurst")
	destroyNextTick = true
	# Check for a collision with the  player, kill 'em all!
	var Above = Game.getObjectAtPosition(position + Vector2.UP * Game.gridSize)
	if Above.is_in_group("Player"):
		Above.playerExplode()
