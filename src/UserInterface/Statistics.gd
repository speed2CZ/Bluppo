extends Control

signal closed

onready var VGrid = $VBoxContainer

var statToNode = {
	"BombsCollected": "Bomb",
	#"BombsUsed": "Bomb", # Bombs collected and used are in the same text field. So they're updated in a spezial way.
	"Deaths": "Death",
	"FishesCollected": "FishFriendly",
	"FishesKilled": "FishEnemy",
	"LevelsFinished": "Level",
	"OxygenCollected": "Oxygen",
	"SeaWeedsCollected": "Seaweed",
	"TilesDestroyed": "Tile",
}

func _ready():
	# Grab the stats and populate the numbers.
	var stats = PlayerData.getRecords()
	for stat in statToNode:
		var nodeLabel = statToNode[stat]
		var node = VGrid.get_node_or_null(nodeLabel + "/" + nodeLabel + "Text")
		if node and stats[stat]:
			# Horibble hardcoded exception, but what can you do?
			if nodeLabel == "Bomb":
				node.text = node.text % [stats[stat], stats["BombsUsed"]]
			else:
				node.text = node.text % stats[stat]

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		close()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			close()

func close():
	emit_signal("closed")
	queue_free()
