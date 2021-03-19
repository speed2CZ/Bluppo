# Level script, used for setting number of fishes requiredto finish it.
extends Node2D

export(int, 1, 999) var requiredFishes = 1

func _ready():
	if requiredFishes < 1:
		push_warning("*WARNING: LevelData: Number of required fishes has to be at least 1! ... setting to 1.")
		requiredFishes = 1
	
	PlayerData.numRequiredFishes = requiredFishes
