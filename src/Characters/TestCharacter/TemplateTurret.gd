extends KinematicBody

var enemy_list = []
var current_enemy
#var closest_enemy
var collision_counter = 0


var target_global_position: = Vector2.ZERO setget set_target_global_position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _physics_process(delta):
	if enemy_list.size() > 0:
		calculate_closest_enemy()
		self.look_at(current_enemy.global_transform.origin,Vector3.UP)
	

func set_target_global_position(value: Vector2) -> void:
	target_global_position = value

func _on_Area_body_entered(body):
	enemy_list.append(body)
	print(body)
	if current_enemy == null:
		current_enemy = body

func _on_Area_body_exited(body):
	enemy_list.erase(body)


#calculates closest enemy and asigns it as current enemy
func calculate_closest_enemy():
	var global_pos = self.global_transform.origin
	for body in enemy_list:
		if global_pos.distance_to(current_enemy.global_transform.origin) > global_pos.distance_to(body.global_transform.origin):
			current_enemy = body
			
func get_target_pos():
	pass
	
