extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = Vector3(10, -10, 10)
var velocity = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	calculate_movement()

func calculate_movement():
	var x = 0
	var z = 0
	var y = speed.y
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
	velocity = Vector3(speed.x * x, y, speed.z * z)
	
	move_and_slide(velocity, Vector3.UP, true)
	pass
