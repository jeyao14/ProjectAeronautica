extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false;
#	self.connect("open_inven", self, "toggle_visible")
	pass # Replace with function body.
	
func _input(event):
	if event.is_action_pressed("pause") and self.visible:
		self.visible = false;

func toggle_visible():
	self.visible = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
