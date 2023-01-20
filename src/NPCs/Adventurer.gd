extends NPC

var speech_text = {
	"idle":"hi there!",
	"interact":"hello to you to!",
}

# Declare member variables here. Examples:

# Called when the node enters the scene tree for the first time.
func _ready():
	title = "Adventurer"
	pass # Replace with function body.
	
func _process(delta):
	if detect and Input.is_action_just_pressed("interact"):
		GLOBALS.MENUS.party_setup_screen.activate_screen();

func _on_HitBox_area_entered(area):
	create_speech_bubble(title, "talk to me to change your party!");
	detect = true;
	

func _on_HitBox_area_exited(area):
	print("player left detection")
	clear_speech_bubble();
	detect = false;
