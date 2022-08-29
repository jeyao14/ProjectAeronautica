extends KinematicBody
class_name Player

export var gravity = -10
export var speed = 10
var velocity = Vector3.ZERO
var facing = 1
onready var active = false  setget active_set

#onready var ANIMATION = get_node("AnimationTree")
onready var ANIMATION = $AnimationTree.get("parameters/playback")
onready var SPRITE = $Sprite3D
onready var HITBOX = get_node("HitBox/CollisionShape")

signal character_active(speed)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationTree.active = true
	self.visible = active
	HITBOX.disabled = !active

func set_facing():
	if is_movement_pressed().x > 0:
		facing = 1
	elif is_movement_pressed().x < 0:
		facing = -1
	
	if facing > 0:
		SPRITE.flip_h = false
	else:
		SPRITE.flip_h = true

func set_animation():
	if is_movement_pressed() != Vector2.ZERO:
		ANIMATION.travel("Run")
	else:
		ANIMATION.travel("Idle")
		
	pass

func is_movement_pressed():
	var x = 0
	var z = 0
	if Input.is_action_pressed("move_forward"):
		z = -1
	elif Input.is_action_pressed("move_back"):
		z = 1

	if Input.is_action_pressed("move_right"):
		x = 1
	elif Input.is_action_pressed("move_left"):
		x = -1
	
	return Vector2(x, z)

func use_attack():
	print("using attack");

func use_ability():
	print("using ability")

func use_ult():
	print("using ult")

func set_hitbox(active):
	HITBOX.set_disabled(!active)

func active_set(new_value):
	active = new_value
	self.visible = new_value
	#HITBOX.set_deferred("disabled", !new_value)
	if(HITBOX): 
		HITBOX.set_disabled(!active)


func hurt_player():
	print("OUCH")
