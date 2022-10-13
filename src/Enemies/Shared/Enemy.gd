extends Node

class_name Enemy

export var max_health = 10
var health
var velocity = Vector3.ZERO

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
