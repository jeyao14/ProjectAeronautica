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
onready var CURSOR = $Cursor;
var dash_timer = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	var c_1 = load(character_path_1)
	var c_2 = load(character_path_2)
	var c_3 = load(character_path_3)
	CHARACTER_1 = c_1.instance()
	CHARACTER_2 = c_2.instance()
	CHARACTER_3 = c_3.instance()
	add_child(CHARACTER_1)
	add_child(CHARACTER_2)
	add_child(CHARACTER_3)
	CHARACTER_1.active = true
	ACTIVE_CHARACTER = CHARACTER_1
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
	else:
		l_speed *= dodge_markiplier;
	
	if Input.is_action_just_pressed("dodgeroll"):
		dodge()
	
	if(is_on_floor()):
		velocity.y = 0

	var l_velocity = velocity.rotated(Vector3.UP, CAMERABOOM.rotation.y).normalized()
	l_velocity.x *= l_speed
	l_velocity.z *= l_speed
	l_velocity.y = gravity
	
	move_and_slide(l_velocity, Vector3.UP, true)
	pass
	
func dodge():
#	move_and_slide(velocity, Vector3.UP, true)
	dash_timer = true;
	ACTIVE_CHARACTER.set_hitbox(false);
	yield(get_tree().create_timer(0.5,false),"timeout");
	dash_timer = false;
	ACTIVE_CHARACTER.set_hitbox(true);
#	while()
	
func process_actions():
	if Input.is_action_pressed("shoot"):
		ACTIVE_CHARACTER.use_attack()
	if Input.is_action_just_pressed("use_ability"):
		ACTIVE_CHARACTER.use_ability()
	if Input.is_action_just_pressed("use_ult"):
		ACTIVE_CHARACTER.use_ult();

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

func get_global_cursor_pos():
	
	var playerpos = ACTIVE_CHARACTER.global_transform.origin
	var dropPlane = Plane(Vector3(0,1,0), playerpos.y)
	
	var mousepos = get_viewport().get_mouse_position();
	var origin = CAMERA.project_ray_origin(mousepos);
	var target = origin + CAMERA.project_ray_normal(mousepos) * 1000;

	CURSOR.global_transform.origin = dropPlane.intersects_ray(origin, target) + Vector3(0,1,0);
	
			

#signals
func swap_character_stats():
	self.speed = ACTIVE_CHARACTER.speed
