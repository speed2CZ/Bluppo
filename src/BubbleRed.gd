extends Bubble

func _ready():
	deadly = true
	type = "Red"

func burst():
	anim.play("burst")
	if visNotifier.is_on_screen():
		Game.playSound("BubbleRedBurst")
	destroyNextTick = true
	# Check for a collision with the  player, kill 'em all!
	var Above = Game.getObjectAtPosition(position + Vector2.UP * Game.gridSize)
	if Above.is_in_group("Player"):
		Above.playerExplode()
