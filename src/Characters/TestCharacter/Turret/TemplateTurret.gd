extends KinematicBody

onready var SPAWNER = $Spawner
onready var LIFESPAN = $LifespanTimer

var alive = true
var enemy_list = []
var current_enemy
var collision_counter = 0

var target_global_position: = Vector2.ZERO setget set_target_global_position

signal turret_death 

# Called when the node enters the scene tree for the first time.
func _ready():
	get_pattern_parameters()
	
func _physics_process(delta):
	if enemy_list.size() > 0 and alive:
		calculate_closest_enemy()
		self.look_at(current_enemy.global_transform.origin,Vector3.UP)
		fire_bullet()
	

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
		if not alive:
			break
		if global_pos.distance_to(current_enemy.global_transform.origin) > global_pos.distance_to(body.global_transform.origin):
			current_enemy = body

func get_target_pos():
	pass
	
func fire_bullet():
	SPAWNER.shoot = true
	SPAWNER.mouse_direction = current_enemy.global_transform.origin

func stop_attack():
	SPAWNER.shoot = false

func get_pattern_parameters():
	SPAWNER.bullet_path = "res://Characters/TestCharacter/Turret/TurretProjectile.tscn";
	SPAWNER.cooldown = 0.5;
	SPAWNER.ammocount = -1;
	SPAWNER.uses_ammo = false;
	SPAWNER.full_auto = true;
	SPAWNER.burst_count = 0;
	SPAWNER.spread_count = 0;
	SPAWNER.spread_angle = 0;
	SPAWNER.random = false;
	SPAWNER.bullet_speed_override = 100;


func _on_LifespanTimer_timeout():
	alive = false
	emit_signal("turret_death")
	call_deferred('free')
