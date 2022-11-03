extends CanvasLayer


var level = null
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBALS.MENUS = self
	GLOBALS.ROOT = get_tree().root
	var main_menu = load(GLOBALS.MAIN_MENU).instance()
	add_child(main_menu)



func clear_menus():
	for menu in self.get_children():
		menu.queue_free()



func load_level(level = "TestLevel"):
	GLOBALS.paused = true
	level = GLOBALS.load_level(level)
	GLOBALS.ROOT.add_child(level)
	GLOBALS.paused = false



	var spawn_node = level.get_node("CharacterSpawnPoint")
	var spawn_pos = Vector3.ZERO
	if spawn_node:
		spawn_pos = spawn_node.global_transform.origin
	
	player = load(GLOBALS.HANDLER).instance()
	player.global_transform.origin = spawn_pos
	GLOBALS.ROOT.add_child(player)
	
