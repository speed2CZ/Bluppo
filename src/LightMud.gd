extends Collectable

onready var animation = $AnimatedSprite

var tick = 0
func _ready():
	# Add tick function
	var _x = Game.connect("tick", self, "spreadDownwards")
	playRandomizedAnimation()

func spreadDownwards():
	tick += 1
	if tick == 5:
		var pos = position + Vector2.DOWN * Game.gridSize
		if not Game.getObjectAtPosition(pos):
			Game.playSound("LightMud")
			Game.spawnObject("objects", "LightMud", pos)

		tick = 0

func playRandomizedAnimation():
	randomize()
	var offset = randi() % animation.get_sprite_frames().get_frame_count("default")
	animation.set_frame(offset)
