extends KinematicBody

class_name Enemy

export var max_health = 10
var health

func _ready():
	health = max_health

func hurt_enemy(damage):
	health -= damage
	if health <= 0:
		kill_enemy()

func kill_enemy():
	
	
	queue_free()
