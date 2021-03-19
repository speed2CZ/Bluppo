extends AllObjects

onready var animation = $AnimatedSprite

var slipOffVector = Vector2.LEFT

func _ready():
	can_move = false
	if "R" in name:
		slipOffVector = Vector2.RIGHT
	playRandomizedAnimation()

func playRandomizedAnimation():
	randomize()
	var offset = randi() % animation.get_sprite_frames().get_frame_count("default")
	animation.set_frame(offset)

func forceSlip():
	return true

func getslipOffVector():
	return slipOffVector
