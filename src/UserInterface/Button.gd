extends TextureButton

var originalText = false

func _on_Button_pressed():
	SoundManager.playSound("UI_Accept")

func _on_Button_focus_entered():
	SoundManager.playSound("UI_Focus")

# Updates the button's label.
# Adds level name after the original text.
func setText(string):
	if not originalText:
		originalText = $Label.text
	$Label.text = originalText + string
