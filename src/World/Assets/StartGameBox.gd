extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	detected = false;
	pass # Replace with function body.

func _process(delta):
	if detected and Input.is_action_just_pressed("interact"):
		GLOBALS.MENUS.unload_game(false)
		GLOBALS.MENUS.load_level("TestLevel")

func _on_HitBox_area_entered(area):
	create_interaction();
	detected = true;
	print("detected ", detected)
	
func _on_HitBox_area_exited(area):
	clear_interaction();
	detected = false;
	print("detected ", detected)
