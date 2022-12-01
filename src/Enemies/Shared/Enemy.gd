extends KinematicBody

class_name Enemy

export var speed = 7
export var gravity = -10
export var velocity = Vector3.ZERO
export var facing = -1
export var max_health = 10
var health
var alive = true
var nav_path = ""
var NAV = null

var damagetext = preload("res://UI/DamageFloatingText.tscn")
var statusicon = preload("res://UI/StatusEffectIcon.tscn")
onready var STATUSCONTAINER = $Node2D/Viewport/Control/Panel/StatusContainer

onready var global_pos = self.global_transform.origin
onready var STATUS_HANDLER = GLOBALS.STATUS_EFFECT_HANDLER.instance()
var statusref = {}

func _ready():
	self.add_child(STATUS_HANDLER)
#	STATUS_HANDLER.PARENT = self
	STATUS_HANDLER.set_defaults(self)
	health = max_health
	#velocity = Vector3(1, velocity.y, 1)
#func _physics_process(delta):
	#self.global_position += velocity\
	
func hurt_enemy(damage):
	health -= damage
	spawn_damage_num(damage)
	if health <= 0:
		kill_enemy()
		
func spawn_damage_num(value):
	var text = damagetext.instance()
	add_child(text)
	text.set_values(value, Vector3(self.global_transform.origin.x, self.global_transform.origin.y+1, self.global_transform.origin.z))

func create_status_icon(var tag, var icon):
	print("create_status_icon() called")
	var status = statusicon.instance();
	STATUSCONTAINER.add_child(status);
	statusref[tag] = status;
	status.set_values(icon);
	
func clear_status(var tag):
	var statustoclear = statusref[tag]
	statustoclear.queue_free();
	statusref.erase(tag)

func kill_enemy():
	
	queue_free()
