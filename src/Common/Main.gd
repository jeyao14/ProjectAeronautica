extends CanvasLayer


var level = null


# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBALS.MENUS = self
	GLOBALS.ROOT = get_tree().root
	GLOBALS.load_level("TestLevel")

func _process(delta):
	if GLOBALS.ROOT != null and level == null:
		print("load level")
		load_level()
	elif level != null:
		set_process(false)


func load_level():
	level = GLOBALS.load_level("TestLevel")
