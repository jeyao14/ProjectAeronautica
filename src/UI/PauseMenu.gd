extends Control

var focus_input = false;

func _ready():
	self.visible = false
	focus_input = true;
	pass # Replace with function body.

func _physics_process(delta):
	if(!GLOBALS.MENUS.inventory.visible) and (!GLOBALS.MENUS.options.visible):
		focus_input = true;

func _input(event):	
	if event.is_action_pressed("pause") and focus_input:
		GLOBALS.paused = !GLOBALS.paused
		self.visible = GLOBALS.paused

func _on_Resume_pressed():
	if GLOBALS:
		GLOBALS.paused = false
		self.visible = false

func _on_Party_pressed():
	GLOBALS.MENUS.inventory.toggle_visible()
	focus_input = false;
	
func _on_Options_pressed():
	GLOBALS.MENUS.options.toggle_visible()
	focus_input = false

func _on_MainMenu_pressed():
#	get_tree().quit()
	if GLOBALS.MENUS:
		GLOBALS.MENUS.unload_game()
	
func _on_Button_pressed():
	get_tree().quit()
