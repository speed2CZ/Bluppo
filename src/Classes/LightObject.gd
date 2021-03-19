# Class for decorative shells and shoe.
# They don't kill player or fishes when they fall on them.
# Purely decorative, no real use for them.
extends MovableObject

class_name LightObject

func _ready():
	heavy = false
