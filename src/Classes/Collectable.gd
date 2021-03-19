# Objects that player can enter.
extends AllObjects

class_name Collectable

func _on_body_entered(body):
	if true or body.is_in_group("Player"):
		Game.playSound("SeaweedCollected")
		queue_free()
	else:
		destroy()
