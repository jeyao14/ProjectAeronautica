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

onready var global_pos = self.global_transform.origin

func _ready():
	health = max_health
	#velocity = Vector3(1, velocity.y, 1)
#func _physics_process(delta):
	#self.global_position += velocity
	
func hurt_enemy(damage):
	health -= damage
	if health <= 0:
		kill_enemy()

func kill_enemy():
	
	
	queue_free()
