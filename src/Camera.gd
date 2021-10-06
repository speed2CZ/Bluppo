extends Camera2D

# Target object to follow.
var target = null

var originalZoom = Vector2()

func _ready():
	originalZoom = zoom

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
		ProjectSettings.get("display/window/size/height") - 96) #96 is height of the bottom texture
	var x = min(originalZoom.x, 1 / (projectResolution.x / (rec.end.x * Game.gridSize)))
	var y = min(originalZoom.y, 1 / (projectResolution.y / (rec.end.y * Game.gridSize)))
	if x < y:
		y = x
	elif y < x:
		x = y
	var zoomVector = Vector2(x, y)
		
	#print("*DEBUG: Camera: Zoom vector set to: ", zoomVector)
	zoom = zoomVector
