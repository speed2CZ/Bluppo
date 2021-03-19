extends Control

signal closed

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		close()

func close():
	emit_signal("closed")
	queue_free()
