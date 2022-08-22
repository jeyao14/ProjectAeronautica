extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = Vector3(10, -10, 10)
var velocity = Vector3.ZERO

onready var CAMERABOOM = $Camera/CameraBoom


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	calculate_movement()
	rotate_handler()

func calculate_movement():
	var x = 0
	var z = 0
	var y = speed.y
	var forward = -CAMERABOOM.transform.basis.z.normalized();
	if Input.is_action_pressed("move_forward"):
		z = -1
	elif Input.is_action_pressed("move_back"):
		z = 1
	
	if Input.is_action_pressed("move_right"):
		x = 1
	elif Input.is_action_pressed("move_left"):
		x = -1
	
	if(is_on_floor()):
#		print("ON FLOOR")
		y = 0
	forward.x *= x * speed.x;
	forward.z *= z * speed.z;
	velocity = Vector3(forward.x, y, forward.z);
	
	move_and_slide(velocity, Vector3.UP, true)
	pass
	
func rotate_handler():
	rotation_degrees.y = $Camera/CameraBoom.rotation_degrees.y;
	pass
	
	
