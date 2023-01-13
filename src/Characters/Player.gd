extends KinematicBody
class_name Player

export var gravity = -10
export var speed = 10

#ALL STATS ARE CAPPED AT 100
export var hp = 100
export var att: float = 1.0
export var def: float = 1.0
export var dex: float = 1.0
export var crit: float = 0.05
export var magsize = 10
export var weap_damage_min = 0
export var weap_damage_max = 10
var ammocount = magsize;
var current_hp = hp;

var velocity = Vector3.ZERO
var facing_x = 1
var facing_z = 0

var idle_anim = "Calli_idle"

const MOVEMENTS = {
	"move_forward":0,
	"move_back":1,
	"move_right":2,
	"move_left":3,
}

var direction_history = []
var motion = -1

onready var active = false  setget active_set
onready var alive = true

onready var STATUS_HANDLER = GLOBALS.STATUS_EFFECT_HANDLER.instance()

#onready var ANIMATION = get_node("AnimationTree")
onready var ANIMATION = $AnimationTree.get("parameters/playback")
onready var SPRITE = $Sprite3D
onready var HITBOX = get_node("HitBox/CollisionShape")
onready var COLLIDER = $CollisionShape

var damagetext = preload("res://UI/DamageFloatingText.tscn")
var statusicon = preload("res://UI/StatusEffectIcon.tscn")
onready var STATUSCONTAINER = $Node2D/Viewport/Control/Panel/StatusContainer
var statusref = {}

signal add_status(tag, icon)
signal remove_status(tag)
signal clear_status

var mouse_direction = Vector3.ZERO

signal character_active(speed)
signal player_stat_changed()
signal player_damaged()
signal ammo_changed()
signal start_reload()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(STATUS_HANDLER)
#	STATUS_HANDLER.PARENT = self
	STATUS_HANDLER.set_defaults(self)
	$AnimationTree.active = true
	self.visible = active
	HITBOX.disabled = !active

func set_facing():
	if facing_x > 0:
		SPRITE.flip_h = false
	else:
		SPRITE.flip_h = true

func set_animation():
	is_movement_pressed();
	if motion > -1:
#		print(motion)
		match motion:
			1:
				facing_z = -1
				ANIMATION.travel("Run_d")
			0:
				facing_z = 1
				ANIMATION.travel("Run_u")
			2:
				facing_x = -1
				facing_z = -1
				ANIMATION.travel("Run_lr")
			3:
				facing_x = 1
				facing_z = -1
				ANIMATION.travel("Run_lr")
#		if recent_dir == 2:
#			ANIMATION.travel("Run_lr")
#		if recent_dir == 1:
#			ANIMATION.travel("Run_u")
#		if recent_dir == 0:
#			ANIMATION.travel("Run_d")
	else:
		if facing_z == -1:
			ANIMATION.travel("Idle_f")
		if facing_z == 1:
			ANIMATION.travel("Idle_r")
	pass

func is_movement_pressed():
	var x = 0
	var z = 0
	motion = -1
	
	# loop through all the directions
	# check to see if a key has been released, and if so, we
	# want to remove it from the array holding all the pressed keys
	for direction in MOVEMENTS.keys():
		if Input.is_action_just_released(direction):
			var index = direction_history.find(direction)
			if index != -1:
				direction_history.remove(index)
		if Input.is_action_just_pressed(direction):
			direction_history.append(direction)
			
	if direction_history.size():
		var direction = direction_history[direction_history.size() - 1]
		motion = MOVEMENTS[direction]


func use_attack():
	print("using attack");
	
func reload():
	print("reloading");

func stop_attack():
	print("stop attack")


func use_ability():
	print("using ability")

func use_ult():
	print("using ult")

func stop_ability():
	pass

func set_hitbox(active):
	HITBOX.set_disabled(!active)

func active_set(new_value):
	active = new_value
	self.visible = new_value
	#HITBOX.set_deferred("disabled", !new_value)
	if(COLLIDER):
		COLLIDER.disabled = !active
	if(HITBOX): 
		HITBOX.disabled = !active

func hurt_player(damage):
	if(active == true):
		current_hp -= damage;
		spawn_damage_num(damage)
		emit_signal("player_damaged")
		
func set_alive():
	if(alive == true):
		alive = false;
		clear_all_status()
		if(GLOBALS.CHARACTER_HANDLER):
			GLOBALS.CHARACTER_HANDLER.find_next_alive_char()
		
func spawn_damage_num(value):
	var text = damagetext.instance()
	add_child(text)
	text.set_values(value, Vector3(self.global_transform.origin.x, self.global_transform.origin.y+2, self.global_transform.origin.z))

func create_status_icon(var tag, var icon):
#	print("create_status_icon() called")
	var status = statusicon.instance();
	STATUSCONTAINER.add_child(status);
	emit_signal("add_status", tag, icon)
	statusref[tag] = status;
	status.set_values(icon);
	
func clear_status(var tag):
	var icontodelete = statusref.get(tag)
	emit_signal("remove_status", tag)
	if(icontodelete):
		icontodelete.queue_free()
		statusref.erase(tag)
	
func clear_all_status():
	emit_signal("clear_status")
	print("cleared_complete")
	
func test(input):
	print(input);
