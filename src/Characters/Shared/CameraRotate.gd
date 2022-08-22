extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var CAMERABOOM = $CameraBoom;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func rotate_camera(delta):
	print("running camera")
	if Input.is_action_pressed("c_rotate_left"):
		CAMERABOOM.rotate_y(5*delta)
		pass
	if Input.is_action_pressed("c_rotate_right"):
		CAMERABOOM.rotate_y(-5*delta)
		pass
	pass
	
func _physics_process(delta):
	rotate_camera(delta)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
