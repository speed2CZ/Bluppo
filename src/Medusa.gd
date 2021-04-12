extends AllObjects

onready var anim = $AnimatedSprite
onready var rays = {
	"rayDown": $RayCast2D_Down,
	"rayLeft": $RayCast2D_Left,
	"rayRight": $RayCast2D_Right,
}

var rng = RandomNumberGenerator.new()

var cycle = 0
var killingCycle = 1

func onTick():
	jiggle()

# Animation has 4 stages, the player can sneak pass only during the first one
func jiggle():
	if cycle == killingCycle:
		for dir in rays:
			if rays[dir].is_colliding() and rays[dir].get_collider().is_in_group("Player"):
				rays[dir].get_collider().playerExplode()
	
	cycle += 1
	if cycle == 3:
		cycle = 0
