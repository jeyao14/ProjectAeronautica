extends Spatial


export var rotate_speed = 5
onready var CAMERABOOM = $CameraBoom

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func rotate_camera(delta):
	if Input.is_action_pressed("c_rotate_left"):
		CAMERABOOM.rotate_y(rotate_speed*delta)
		pass
	if Input.is_action_pressed("c_rotate_right"):
		CAMERABOOM.rotate_y(-rotate_speed*delta)
		pass
	pass
	
func _physics_process(delta):
	rotate_camera(delta)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
