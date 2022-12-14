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
var facing = 1
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
