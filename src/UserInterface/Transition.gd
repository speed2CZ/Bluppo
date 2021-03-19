extends Control

onready var animation = $AnimationPlayer

func play(animToPlay):
	animation.play(animToPlay)
