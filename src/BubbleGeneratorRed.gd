extends BubbleGenerator

func _ready():
	# Since the red bubbles can kill the player, there has to be 2 tiles between them
	# so the player can get through.
	bubbleTick = 3
	bubbleType = "Red"
	
