extends KinematicBody

export var gravity = -10
export var speed = 1
export var dodge_markiplier = 3;
var velocity = Vector3.ZERO

var ray_origin = Vector3();
var ray_target = Vector3();

export var character_path_1 = "res://Characters/TestCharacter/TestCharacter.tscn"
export var character_path_2 = "res://Characters/TestCharacter2/TestCharacter2.tscn"
export var character_path_3 = "res://Characters/TestCharacter3/TestCharacter3.tscn"
var CHARACTER_1
var CHARACTER_2
var CHARACTER_3
var ACTIVE_CHARACTER 
onready var CAMERABOOM = $CameraObject/CameraBoom
onready var CAMERA = $CameraObject/CameraBoom/Camera
onready var CAMERARAY = $CameraObject/CameraBoom/Camera/RayCast
onready var CURSOR = $Cursor;
onready var GUI = $GUI;
var dash_timer = false;
var can_dash = true
var dash_cooldown = .5

# Called when the node enters the scene tree for the first time.
func _ready():
	GLOBALS.CHARACTER_HANDLER = self
	
	var c_1 = load(character_path_1)
	var c_2 = load(character_path_2)
	var c_3 = load(character_path_3)
	CHARACTER_1 = c_1.instance()
	CHARACTER_2 = c_2.instance()
	CHARACTER_3 = c_3.instance()
	add_child(CHARACTER_1)
	add_child(CHARACTER_2)
	add_child(CHARACTER_3)
	
	#change the next two lines to change the starting active character
	CHARACTER_1.active = true
	ACTIVE_CHARACTER = CHARACTER_1
	
#	ACTIVE_CHARACTER.set_hitbox(false)
#	CHARACTER_2.set_hitbox(false)
#	CHARACTER_3.set_hitbox(false)
	
	GUI.set_players(CHARACTER_1, CHARACTER_2, CHARACTER_3)
	swap_character_stats()


func _physics_process(delta):
	calculate_movement()
	swap_handler()
	process_actions()
	get_global_cursor_pos()

func calculate_movement():
	var l_speed = speed;
	if(!dash_timer):
		if Input.is_action_pressed("move_forward"):
			velocity.z = -1
		elif Input.is_action_pressed("move_back"):
			velocity.z = 1
		else:
			velocity.z = 0;
		if Input.is_action_pressed("move_right"):
			velocity.x = 1
		elif Input.is_action_pressed("move_left"):
			velocity.x = -1
		else:
			velocity.x = 0;
		
		if Input.is_action_just_pressed("dodgeroll") and can_dash:
			dodge()
	else:
		l_speed *= dodge_markiplier;
	
	
	
	if(is_on_floor()):
		velocity.y = 0

	var l_velocity = velocity.rotated(Vector3.UP, CAMERABOOM.rotation.y).normalized()
	l_velocity.x *= l_speed
	l_velocity.z *= l_speed
	l_velocity.y = gravity
	
	move_and_slide(l_velocity, Vector3.UP, true)
	pass
	
func dodge():
	can_dash = false
	dash_timer = true;
	ACTIVE_CHARACTER.set_hitbox(false);
	yield(get_tree().create_timer(0.5,false),"timeout");
	dash_timer = false;
	ACTIVE_CHARACTER.set_hitbox(true);
	yield(get_tree().create_timer(dash_cooldown, false), "timeout")
	can_dash = true
	
#	while()
	
func process_actions():
	if Input.is_action_just_pressed("shoot"):
		ACTIVE_CHARACTER.use_attack()
	if Input.is_action_just_released("shoot"):
		ACTIVE_CHARACTER.stop_attack()
	if Input.is_action_just_pressed("reload"):
		ACTIVE_CHARACTER.reload()
	if Input.is_action_just_pressed("use_ability"):
		ACTIVE_CHARACTER.use_ability()
	if Input.is_action_just_released("use_ability"):
		ACTIVE_CHARACTER.stop_ability()
	if Input.is_action_just_pressed("use_ult"):
		ACTIVE_CHARACTER.use_ult();
	

func swap_handler():
	var next_character = null
	if Input.is_action_just_pressed("swap_character_1") and CHARACTER_1.alive:
		next_character = CHARACTER_1
		CHARACTER_2.active = false
		CHARACTER_3.active = false
	elif Input.is_action_just_pressed("swap_character_2") and CHARACTER_2.alive:
		next_character = CHARACTER_2
		CHARACTER_1.active = false
		CHARACTER_3.active = false
	elif Input.is_action_just_pressed("swap_character_3") and CHARACTER_3.alive:
		next_character = CHARACTER_3
		CHARACTER_1.active = false
		CHARACTER_2.active = false
	if (next_character):
		ACTIVE_CHARACTER.active = false
		next_character.active = true
		ACTIVE_CHARACTER = next_character
		GUI.setActive()
		swap_character_stats()

func get_global_cursor_pos():
	# get world state reference
	var space = get_world().direct_space_state
	var playerpos = ACTIVE_CHARACTER.global_transform.origin

	# create raycast from camera to mouse
	var mousepos = get_viewport().get_mouse_position();
	var origin = CAMERA.project_ray_origin(mousepos);
	var target = origin + CAMERA.project_ray_normal(mousepos) * 1000;
	
	# find intersection between raycast and worldz
	var result = space.intersect_ray(origin, target);
	
	# if result has a value update cursor to result.position
	if(result):
		CURSOR.visible = true;
		CURSOR.global_transform.origin = result.position;
#		print(result.position)
		ACTIVE_CHARACTER.mouse_direction = result.position
#		print(ACTIVE_CHARACTER.mouse_direction)
	# else turn off visibility of cursor
	else:
		CURSOR.visible = false;

#signals
func swap_character_stats():
	self.speed = ACTIVE_CHARACTER.speed

func find_next_alive_char():
	print("running find_next_alive_char")
	var next_character = null
	if CHARACTER_1.alive and !CHARACTER_1.active:
		next_character = CHARACTER_1
		CHARACTER_2.active = false
		CHARACTER_3.active = false
	elif CHARACTER_2.alive and !CHARACTER_2.active:
		next_character = CHARACTER_2
		CHARACTER_1.active = false
		CHARACTER_3.active = false
	elif CHARACTER_3.alive and !CHARACTER_3.active:
		next_character = CHARACTER_3
		CHARACTER_1.active = false
		CHARACTER_2.active = false
	if (next_character):
		ACTIVE_CHARACTER.active = false
		next_character.active = true
		ACTIVE_CHARACTER = next_character
		GUI.setActive()
		swap_character_stats()
