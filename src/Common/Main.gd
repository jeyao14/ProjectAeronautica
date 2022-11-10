extends CanvasLayer


var level = null
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBALS.MENUS = self
	GLOBALS.ROOT = get_tree().root
	var main_menu = load(GLOBALS.MAIN_MENU).instance()
	add_child(main_menu)

func main_menu():
	var main_menu = load(GLOBALS.MAIN_MENU).instance()
	self.add_child(main_menu)

func clear_menus():
	for menu in self.get_children():
		menu.queue_free()


func load_level(level = "TestLevel"):
	GLOBALS.paused = true
	level = GLOBALS.load_level(level)
	GLOBALS.ROOT.add_child(level)
	
	
	
	var spawn_node = level.get_node("CharacterSpawnPoint")
	var spawn_pos = Vector3.ZERO
	if spawn_node:
		spawn_pos = spawn_node.global_transform.origin
	
	player = load(GLOBALS.HANDLER).instance()
	player.global_transform.origin = spawn_pos
	GLOBALS.ROOT.add_child(player)
	
	
	var pause_menu = load(GLOBALS.PAUSE_MENU).instance()
	GLOBALS.paused = false
	self.add_child(pause_menu)
	
#	var gui = load(GLOBALS.GUI).instance()
#	self.add_child(gui)
#	gui.setup_signals()


func unload_game():
	GLOBALS.paused = true
	clear_menus()
	
	level = null
	player = null
	
	for node in GLOBALS.ROOT.get_children():
		if not (node == self or node.name == "GLOBALS" or node.name == "ImportData"):
			node.queue_free()
	
	main_menu()
	
	GLOBALS.paused = false
