extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var gravity = -10
export var speed = 10
var velocity = Vector3.ZERO

onready var CAMERABOOM = $Camera/CameraBoom
onready var PLAYER = $Calliope


# Called when the node enters the scene tree for the first time.
func _ready():
	PLAYER.speed = speed
	pass # Replace with function body.


func _physics_process(delta):
	calculate_movement()
#	rotate_handler()

func calculate_movement():
	var x = 0
	var z = 0
	var y = 0
#	var forward = -CAMERABOOM.transform.basis.z.normalized();
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
	
	velocity = Vector3(x, y, z);
	velocity = velocity.rotated(Vector3.UP, CAMERABOOM.rotation.y).normalized()
	velocity.x *= speed
	velocity.z *= speed
	velocity.y = gravity
	
	move_and_slide(velocity, Vector3.UP, true)
	pass
	
func rotate_handler():
#	rotation_degrees.y = $Camera/CameraBoom.rotation_degrees.y;
	pass
	
	
