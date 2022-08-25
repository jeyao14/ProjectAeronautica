extends KinematicBody

export var gravity = -10
export var speed = 1
var velocity = Vector3.ZERO

export var character_path_1 = "res://Characters/TestCharacter/TestCharacter.tscn"
export var character_path_2 = "res://Characters/TestCharacter2/TestCharacter2.tscn"
export var character_path_3 = "res://Characters/TestCharacter3/TestCharacter3.tscn"
var CHARACTER_1
var CHARACTER_2
var CHARACTER_3
var ACTIVE_CHARACTER 
onready var CAMERABOOM = $Camera/CameraBoom


# Called when the node enters the scene tree for the first time.
func _ready():
	var c_1 = load(character_path_1)
	var c_2 = load(character_path_2)
	var c_3 = load(character_path_3)
	CHARACTER_1 = c_1.instance()
	CHARACTER_2 = c_2.instance()
	CHARACTER_3 = c_3.instance()
	CHARACTER_1.active = true
	ACTIVE_CHARACTER = CHARACTER_1
	add_child(CHARACTER_1)
	add_child(CHARACTER_2)
	add_child(CHARACTER_3)


func _physics_process(delta):
	calculate_movement()
	swap_handler()
	

func calculate_movement():
	var x = 0
	var z = 0
	var y = 0
	if Input.is_action_pressed("move_forward"):
		z = -1
	elif Input.is_action_pressed("move_back"):
		z = 1
	
	if Input.is_action_pressed("move_right"):
		x = 1
	elif Input.is_action_pressed("move_left"):
		x = -1
	
	if(is_on_floor()):
		y = 0
	
	velocity = Vector3(x, y, z);
	velocity = velocity.rotated(Vector3.UP, CAMERABOOM.rotation.y).normalized()
	velocity.x *= speed
	velocity.z *= speed
	velocity.y = gravity
	
	move_and_slide(velocity, Vector3.UP, true)
	pass
	
func swap_handler():
	var next_character = null
	if Input.is_action_just_pressed("swap_character_1"):
		next_character = CHARACTER_1
	elif Input.is_action_just_pressed("swap_character_2"):
		next_character = CHARACTER_2
	elif Input.is_action_just_pressed("swap_character_3"):
		next_character = CHARACTER_3
	if (next_character):
		ACTIVE_CHARACTER.active = false
		next_character.active = true
		ACTIVE_CHARACTER = next_character
		swap_character_stats()
#signals
func swap_character_stats():
	self.speed = ACTIVE_CHARACTER.speed
