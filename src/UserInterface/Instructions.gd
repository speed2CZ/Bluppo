extends Control

signal closed

onready var VGrid = $VBoxContainer

var currentPage = 1
var pages = [
	{
		["res://assets/world/Surface_1.png"]: "THIS IS THE SURFACE. YOU'LL STAY UNDER IT ALL THE TIME...",
		["res://assets/objects/Green.png"]: "THIS IS SOME KIND OF A SOLID GROUND, IN FACT IT IS A MIXTURE OF MUDD AND DIRT. IT CAN HOLD OBJECTS ON TOP OF IT SO THAT THE OBJECTS WON'T FALL DOWN. YOU CAN GO THROUGH IT, AND IT WILL VANISH.",
		["res://assets/objects/Destroyable_Wall_2.png"]: "THIS IS A BRICK WALL. YOU CAN'T MOVE IT OR GO THROUGH IT, BUT YOU CAN USE A BOMB TO DESTROY IT...",
		["res://assets/world/Wall_3.png"]: "THIS IS SIMILAR TO A BRICK WALL. THE ONLY DIFFERENCE IS THAT OBJECTS WILL FALL OFF IF THEY'RE ON TOP OF IT",
		["res://assets/objects/Destroyable_Bars_Slippery.png", "res://assets/objects/Destroyable_Bars_H.png", "res://assets/objects/Destroyable_Bars_V.png", "res://assets/objects/Destroyable_Wall_1_H.png", "res://assets/objects/Destroyable_Wall_1_V.png"]: "THOSE ARE DIFFERENT KINDS OF WALLS. YOU CAN DESTROY THEM (IF YOU HAVE A BOMB)...",
		["res://assets/world/Wall_1.png"]: "THIS IS ALSO A WALL, BUT YOU CAN'T DESTROY IT.",
		["res://assets/world/Wall_Metal.png"]: "THIS IS ALSO INDESTRUCTIBLE.",
	},
	{
		["empty1"]: "CONTINUING GAME OBJECTS...",
		["res://assets/world/Platform_1.png"]: "THIS IS A SOLID GROUND. IT CAN KEEP OBJECTS ON TOP OF IT BUT THOSE OBJECTS CAN FALL DOWN.",
		["res://assets/world/Wall_2.png"]: "ANOTHER INDESTRUCTIBLE WALL...",
		["res://assets/objects/Rock.png"]: "THIS IS A STONE. IT CAN KILL YOU IF IT FALLS ON YOU... AVOID THAT!... YOU CAN DESTROY IT AND MOVE IT, YOU CAN ALSO KILL SOMEONE WITH IT IF YOU ARE CLEVER ENOUGH.",
		["res://assets/objects/Box.png"]: "THIS IS A WOODEN BOX. IT CAN ALSO KILL YOU... BE CAREFUL!...",
		["res://assets/objects/Bubble_Generator_L_1.png", "res://assets/objects/Bubble_Generator_R_1.png", "res://assets/objects/Heavy_1.png", "res://assets/objects/Movable_Lite_2.png", "res://assets/objects/Movable_Lite_1.png", "res://assets/objects/Movable_Lite_3.png", "res://assets/objects/Coral_Green_1.png", "res://assets/objects/Coral_Red_1.png", "res://assets/objects/Coral_Blue_1.png"]: "",
		["empty2"]: "THESE OBJECTS HAVE NO PARTICULAR PURPOSE EXCEPT MAYBE TO STOP YOU.",
		["empty3"]: "THAT IS NOT ALL FOLKS!",
		["empty4"]: "THERE ARE MANY OTHER OBJECTS WHICH HAVE NO PURPOSE AND ARE USED FOR LEVEL DOCERATION... WE HAVE NO TIME TO DESCRIBE THEM ALL, SO PLAY THE GAME AND SEE FOR YOURSELF!...",
	},
	{
		["empty1"]: "NOW THAT YOU ARE FAMILIAR (HOPEFULLY) WITH THE GAME OBJECTS, WE CAN INTRODUCE YOU TO YOUR FRIENDS AND ENEMIES. YOUR ENEMIES ARE MOSTLY FISH... I GUESS IT WON'T BE TOO HARD TO RECOGNIZE THEM.",
		["res://assets/fishes/Fish_Taba_Down.png"]: "THIS IS YOUR MOST DANGEROUS ENEMY. (PRETTY FACE). NOW READ CAREFULLY... YOU DON'T WANT TO KNOW HIM (IF YOU WANT TO LIVE). HE'LL EAT YOU WITHOUT ANY WARNING, SO STAY AWAY.",
		["res://assets/fishes/Fish_Haha_Down.png"]: "THIS SHARK LIKES YOU VERY MUCH, ESPECIALLY FOR BREAKFAST. BUT YOU CAN EASILY ESCAPE BECAUSE THE SHARK ALWAYS LAUGHS WHEN 'DINNER IS SERVED' THIS SHARK WILL EAT FISH THAT YOU HAVE TO COLLECT, BE QUICK!",
		["res://assets/objects/Medusa_1.png"]: "THIS JELLYFISH CAN 'KISS' YOU IF YOU'RE UNDER OR NEAR IT.",
		["res://assets/objects/Bubble_Generator_1.png"]: "THIS SHELL MAKES VERY DANGEROUS BUBBLES. AVOID THEM AND STAY ALIVE!",
		["empty2"]: "NO MORE ENEMIES (LUCKY YOU)... BUT, THAT DOESN'T MEAN THAT NOTHING ELSE CAN KILL YOU. YOU MUST BE QUICK AND CAREFUL IF YOU WANT TO ADVANCE TO OTHER LEVELS."
	},
	{
		["empty1"]: "OK, THAT'S ENOUGH ABOUT THE BAD GUYS, NOW WE'LL SEE WHO YOUR 'FRIENDS' ARE... THE WORD 'FIRNEDS' MEANS THAT THEY WILL NOT KILL YOU, NOT ON PURPOSE ANYWAY. HOWEVER... ACCIDENTS DO HAPPEN. OK! LE'S GET DOWN TO BUSINESS...",
		["res://assets/fishes/Fish_3_Down.png", "res://assets/fishes/Fish_2_Down.png"]: "COLLECT THESE FISH!",
		["res://assets/fishes/Fish_1_1.png"]: "AND COLLECT THIS ONE TOO!",
		["empty2"]: "YOU WILL HAVE TO COLLECT THESE THREE FISH IN ORDER TO OPEN THE EXIT TO THE NEXT LEVEL.",
		["res://assets/objects/Bomb.png"]: "COLLECT THIS AS WELL! YOU'LL BE NEEDING THIS BOMB, FIRST TO SATISFY YOUR DESTRUCTIVE NEEDS, AND SECOND, TO GET THINGS OUT OF YOUR WAY.",
		["empty3"]: "TO USE THE BOMB... PRESS YOUR 'FIRE' KEY AND THEN, IF YOU HAVE A BOMB (YOU CAN SEE IT ON THE SCOREBAR), PRESS THE DIRECTION KEY WHERE YOU WANT TO DROP IT AND ... GET THE HELL OUT OF THERE!",
	},
	{
		["empty1"]: "NOW THAT YOU KNOW HOW TO USE THE BOMB, YOU MUST KNOW THAT IT'S NOT WISE TO PLAY WITH IT, AND YOU MUST USE IT VERY CAREFULLY IN ORDER TO ACHIEVE SOMETHING. OH! I ALMOST FORGOT! YOU DON'T HAVE ALL THE TIME IN THE WORLD BECASUE YOU CAN'T BREATHE UNDER THE WATER... UNLESS YOU HAVE THIS:",
		["res://assets/objects/Oxygen_1.png"]: "THIS IS OXYGEN. YOU'LL BE NEEDING IT IN ORDER TO STAY ALIVE.",
		["empty2"]: "IF YOU WANT TO KNOW HOW LONG YOU HAVE BEEN PLAYING, TAKE A LOOK AT THE SCOREBAR. NOW, LET'S CONTINUE...",
		["res://assets/objects/Bubble_Generator_3.png"]: "THIS SHELL PRODUCES BUBBLES. DON'T BE AFRAID, BUBBLES AREN'T DANGEROUS.",
		["res://assets/objects/Bubble_Generator_2.png"]: "THIS SHELL MAKES BIG BUBBLES. THOSE BIG BUBBLES WILL STOP YOU IF YOU TRY TO GO THROUGH THEM.",
		["res://assets/objects/Heavy_Mud_1.png"]: "THIS IS MUDD. YOU CAN GO THROUGH IT. BUT FISH CAN'T",
		["empty3"]: "MUDD WILL KEEP ON SPREADING ALL THE TIME (THIS CAN HELP YOU A LOT!).",
		["res://assets/objects/Light_Mud_1.png"]: "THIS IS SIMILAR TO MUDD BUT IT WILL SPREAD IN THE DOWNWARD DIRECTION.",
	},
	{
		["empty1"]: "NOW COMES THE REAL STUFF...",
		["res://assets/fishes/Fish_Purple_Down.png"]: "THIS IS YOUR BEST FRIEND. HE'LL BE EATING YOUR ENEMIES THROUGHOUT THE GAME, SO DON'T KILL HIM!",
		["res://assets/fishes/Friendly_Blue_Down.png"]: "THIS IS ALSO YOUR FIREND. HE'LL BE EATING YOUR ENEMIES AS WELL, BUT LESS OFTEN. HE MUST NOT BE FRENCH!",
		["res://assets/fishes/Fist_Red_Down.png"]: "THIS FISH WILL STICK TO THE SHARKS AND EVENTUALLY PREVENT THEM FROM MOVING AROUND.",
		["res://assets/fishes/Fish_Yellow_Down.png"]: "THIS FISH STICKS ON YOUR FISH THAT YOU HAVE TO COLLECT. YOU MUST BE VERY CAREFUL BECAUSE... NAH, YOU'LL SEE FOR YOURSELF!",
		["res://assets/objects/Potion_1.png"]: "THIS POTION TURNS A SHARK INTO A FISH",
		["empty2"]: "FINALLY! FINISHED! THAT'S ALL FOLKS!...",
		["res://assets/Bonus.png"]: "HEY! HOW DID THIS GET IN HERE? HE'S IN THE WRONG GAME!!!!!!!!!",
		["empty3"]: "WELL, I HOPE YOU ARE READY TO PLAY THIS GREAT GAME.",
	}
]

func _ready():
	loadPage(1)

func _unhandled_input(event):
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		close()
	elif event.is_action_pressed("ui_right"):
		loadPage(currentPage + 1)
	elif event.is_action_pressed("ui_left"):
		loadPage(currentPage - 1)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			loadPage(currentPage + 1)
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			loadPage(currentPage - 1)

func loadPage(num):
	print("Loading page" + str(num))
	currentPage = min(max(1, num), pages.size())
	
	var currData = VGrid.get_children()
	for i in currData.size():
		currData[i].queue_free()


	var data = pages[currentPage - 1]
	for icons in data:
		var HBox = HBoxContainer.new()
		VGrid.add_child(HBox)

		for i in icons.size():
			var iconName = icons[i]
			if not "empty" in iconName:
				var icon = TextureRect.new()
				icon.texture = load(iconName)
				icon.rect_min_size = Vector2(64, 64)
				icon.expand = true
				HBox.add_child(icon)

		var text = load("res://scenes/screens/InstructionsText.tscn").instance()
		text.text = data[icons]
		text.rect_min_size = Vector2(1280 - 64 * HBox.get_child_count(), 64)
		HBox.add_child(text)

func close():
	emit_signal("closed")
	queue_free()
