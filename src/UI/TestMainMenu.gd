extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_Game_pressed():
	if GLOBALS.MENUS:
		GLOBALS.MENUS.clear_menus()
		GLOBALS.MENUS.load_level("Hubworld")
	pass # Replace with function body.
	
func _on_Continue_pressed():
	pass # Replace with function body.

func _on_Options_pressed():
	GLOBALS.MENUS.options.toggle_visible()

func _on_End_Game_pressed():
	get_tree().quit()
