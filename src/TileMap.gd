extends TileMap

var indexes = {}
var dataFishes = {
	"StaticFish": 59,
	"CollectableGreenFish": 60,
	"CollectableBlueFish": 61,
	"BrownFish": 62,
	"FriendlyPurpleFish": 63,
	"EnemyBlueFish": 64,
	"YellowFish": 65,
	"RedFish": 66,
	"FriendlyBlueFish": 67,
}

var dataObjects = {
	"SteelBarrel": 44,
	"WoodenBarrel": 45,
	"Bomb": 43,
	"Box": 35,
	"BubbleGeneratorRed": 56,
	"BubbleGeneratorBig": 57,
	"BubbleGeneratorSmall": 58,
	"BubbleGeneratorL": 73,
	"BubbleGeneratorR": 74,
	"DestroyableBarsV": 69,
	"DestroyableBarsH": 68,
	"DestroyableBarsSlippery": 42,
	"DestroyableWall1": 37,
	"DestroyableWall2_H": 38,
	"DestroyableWall2_V": 39,
	"Exit": 55,
	"Seaweed": 34,
	"Treasure": 46,
	"LightMud": 54,
	"HeavyMud": 77,
	"Medusa": 53,
	"MovingCoralL": 75,
	"MovingCoralR": 76,
	"Shell": 47,
	"Shoe": 48,
	"Shell_Alt": 49,
	"Oxygen": 50,
	"Potion": 51,
	"Present": 52,
	"Rock": 36,
	"GroundLeft1": 9,
	"GroundLeft2": 28,
	"GroundRight1": 10,
	"GroundRight2": 29,
	"Platform": 33,
	"WallRock": 3,
	"CoralBlue": 70,
	"CoralGreen": 71,
	"CoralRed": 72,
}

#var dataWorld = {
#
#}

func _ready():
	# Use this tilemap to set up the main array and grid size
	Game.initWorldArray(self)
	
	populateWorldFromTileMap(dataFishes, "fishes")
	populateWorldFromTileMap(dataObjects, "objects")
#	populateWorldFromTileMap(dataWorld, "world")

	# Register walls and whatever left
	var cells = get_used_cells()
	for pos in cells:
		Game.registerTileMap(self, pos * Game.gridSize)

# Uses the arrays above to spawn actual nodes for each tile that needs it
func populateWorldFromTileMap(data, folder):
	for objectName in data:
		for pos in get_used_cells_by_id(data[objectName]):
			# Delete the cell from the tilemap since it's replaced by the actual object
			set_cell(pos.x, pos.y, -1)
			Game.spawnObject(folder, objectName, pos * Game.gridSize)

func getIndex(string):
	if not indexes.has(string):
		indexes[string] = 0
	indexes[string] += 1
	return str(indexes[string])

func isSlippery():
	return false

func canBeKilled():
	return false
