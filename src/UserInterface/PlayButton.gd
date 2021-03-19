extends Button

func _on_button_up():
	var root = get_node("/root")

	var ui_resource = load("res://scenes/Screens/UserInterface.tscn")
	var ui = ui_resource.instance()
	root.add_child(ui)

	#var next_level_resource = load("res://scenes/levels/Level_Test.tscn")
	#var next_level = next_level_resource.instance()
	#get_node("/root/UI/UserInterface/ViewportContainer1/Viewport1").add_child(next_level)



	get_parent().get_parent().visible = false
