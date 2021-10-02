# Objects that generate bubbles above them.
extends MovableObject

class_name BubbleGenerator

var tick = 0
var bubbleTick = 2
var bubbleType = "Small"

func onTick():
	moveObject()
	bubbleThread()

# Generate bubbles every other tick
func bubbleThread():
	tick += 1
	if tick == bubbleTick:
		var blocked = false
		for i in range(1, bubbleTick + 1): # (1, 4)
			var Above = Game.getObjectAtPosition(position + Vector2.UP * i * Game.gridSize)
			if Above:# and not Above.is_in_group("Bubble"):
				blocked = true
				break
		
		if not blocked:
			Game.spawnObject("objects", "Bubble" + bubbleType, position + Vector2.UP * Game.gridSize)

		tick = 0
