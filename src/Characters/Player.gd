extends KinematicBody

class_name Player

export var speed = Vector3(10, -10, 10)
var velocity = Vector3.ZERO
var facing = 1

#onready var ANIMATION = get_node("AnimationTree")
onready var ANIMATION = $AnimationTree.get("parameters/playback")
onready var SPRITE = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationTree.active = true
	pass # Replace with function body.

func set_facing():
	if velocity.x > 0:
		facing = 1
	elif velocity.x < 0:
		facing = -1
	SPRITE.scale.x = facing

func set_animation():
	if velocity.x == 0 and velocity.z == 0:
		ANIMATION.travel("Idle")
	else:
		ANIMATION.travel("Run")
	pass

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

func hurt_player():
	print("OUCH")
