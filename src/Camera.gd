extends Camera2D

# Target object to follow.
var target = null

func _physics_process(_delta):
	if target:
		position = target.position

func setUpCamera(tileMap):
	var rec = tileMap.get_used_rect()
	limit_left = rec.position.x * Game.gridSize
	limit_right = rec.end.x * Game.gridSize
	limit_top = rec.position.y * Game.gridSize
	limit_bottom = rec.end.y * Game.gridSize

	var projectResolution = Vector2(ProjectSettings.get("display/window/size/width"),
		ProjectSettings.get("display/window/size/height"))
	var x = min(zoom.x, 1 / (projectResolution.x / (rec.end.x * Game.gridSize)))
	var y = min(zoom.y, 1 / (projectResolution.y / (rec.end.y * Game.gridSize)))
	if x < y:
		y = x
	elif y < x:
		x = y
	var zoomVector = Vector2(x, y)
		
	#print("*DEBUG: Camera: Zoom vector set to: ", zoomVector)
	zoom = zoomVector
