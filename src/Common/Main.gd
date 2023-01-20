extends CanvasLayer


var level = null
var level_name = ""
var player = null
var inventory = null
var options = null
var party = {"1":GLOBALS.MARIA, "2":GLOBALS.RHODES,"3":GLOBALS.OLIVE}
var party_setup_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBALS.MENUS = self
	GLOBALS.ROOT = get_tree().root
	var main_menu = load(GLOBALS.MAIN_MENU).instance()
	var options_menu = load(GLOBALS.OPTIONS_MENU).instance()
	add_child(main_menu)
	add_child(options_menu)
	options = options_menu

func main_menu():
	var main_menu = load(GLOBALS.MAIN_MENU).instance()
	var options_menu = load(GLOBALS.OPTIONS_MENU).instance()
	self.add_child(main_menu)
	self.add_child(options_menu)
	options = options_menu
	
func load_default_party():
	pass

func clear_menus():
	for menu in self.get_children():
		menu.queue_free()

func load_level(level):
	print(level)
	GLOBALS.paused = true
	self.level = GLOBALS.load_level(level)
	level_name = level
	GLOBALS.ROOT.add_child(self.level)

	var spawn_node = self.level.get_node("CharacterSpawnPoint")
	var spawn_pos = Vector3.ZERO
	if spawn_node:
		spawn_pos = spawn_node.global_transform.origin
	
	player = load(GLOBALS.HANDLER).instance()
	player.CHARACTER_PATH_1 = party["1"]
	player.CHARACTER_PATH_2 = party["2"]
	player.CHARACTER_PATH_3 = party["3"]
	player.global_transform.origin = spawn_pos
	GLOBALS.ROOT.add_child(player)
	
	
	var pause_menu = load(GLOBALS.PAUSE_MENU).instance()
	var inventory_menu = load(GLOBALS.PARTY_MENU).instance()
	var options_menu = load(GLOBALS.OPTIONS_MENU).instance()
	
	var party_setup = load(GLOBALS.PARTY_SETUP).instance()
	self.add_child(party_setup)
	party_setup_screen = party_setup
	
	GLOBALS.paused = false
	self.add_child(pause_menu)
	self.add_child(inventory_menu)
	self.add_child(options_menu)
	inventory = inventory_menu
	options = options_menu
	
	
#	var gui = load(GLOBALS.GUI).instance()
#	self.add_child(gui)
#	gui.setup_signals()

func restart_game():
	var temp_level_name = level_name
	unload_game(false)
	load_level(temp_level_name)

func unload_game(main_menu = true):
	GLOBALS.paused = true
	clear_menus()
	
	level = null
	level_name = ""
	player = null
	
	for node in GLOBALS.ROOT.get_children():
		if not (node == self or node.name == "GLOBALS" or node.name == "ImportData"):
			node.queue_free()
	
	if(main_menu):
		main_menu()
	
	GLOBALS.paused = false
