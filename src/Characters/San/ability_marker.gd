extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func resize_mesh(new_size):
	self.scale.z = new_size;

func rotate_mesh(new_rotation):
	self.rotation_degrees.y = new_rotation;
