extends Control

onready var TouchUp = $UpDown/ControlUp/TouchUp
onready var TouchDown = $UpDown/ControlDown/TouchDown
onready var TouchLeft = $LeftRight/ControlLeft/TouchLeft
onready var TouchRight = $LeftRight/ControlRight/TouchRight
onready var TouchMenuBack = $PauseBack/BackControl/TouchBack
onready var TouchPause = $PauseBack/PauseControl/TouchPause

var menuTexture = preload("res://assets/ui/Button_Menu.png")
var backTexture = preload("res://assets/ui/Button_Back.png")

func changeControls(pauseMenu):
	if pauseMenu:
		TouchUp.set_action("ui_up")
		TouchDown.set_action("ui_down")
		TouchLeft.set_action("ui_left")
		TouchRight.set_action("ui_right")
		TouchMenuBack.set_texture(backTexture)
		TouchPause.visible = false
	else:
		TouchUp.set_action("Player1_Up")
		TouchDown.set_action("Player1_Down")
		TouchLeft.set_action("Player1_Left")
		TouchRight.set_action("Player1_Right")
		TouchMenuBack.set_texture(menuTexture)
		TouchPause.visible = true
