extends KinematicBody

onready var SPAWNER = $Spawner
onready var LIFESPAN = $LifespanTimer

var alive = true
var enemy_list = []
var current_enemy
var collision_counter = 0

var target_global_position: = Vector3.ZERO

signal turret_death 

# Called when the node enters the scene tree for the first time.
func _ready():
	get_pattern_parameters()

func _physics_process(delta):
	if enemy_list.size() > 0 and alive:
		calculate_closest_enemy()
		self.look_at(target_global_position,Vector3.UP)
		fire_bullet()
	else:
		stop_attack()
		

func _on_Area_body_entered(body):
	enemy_list.append(body)
	print(body)
	if target_global_position == Vector3.ZERO:
		target_global_position = body.global_transform.origin

func _on_Area_body_exited(body):
	enemy_list.erase(body)
	target_global_position = Vector3.ZERO


#calculates closest enemy and asigns it as current enemy
func calculate_closest_enemy():
	# get position of turret
	var global_pos = self.global_transform.origin
	
	# iterate through enemy list and find the closest position relative to turret
	for enemy in enemy_list:
		var enemy_pos = enemy.global_transform.origin
		
		# if this enemy's position is closer than the current target position (or target pos = 0), set new target position = enemy pos
		
		if global_pos.distance_to(enemy_pos) < global_pos.distance_to(target_global_position) or target_global_position == Vector3.ZERO:
			target_global_position = enemy_pos
	

func get_target_pos():
	pass
	
func fire_bullet():
	SPAWNER.shoot = true
	SPAWNER.mouse_direction = target_global_position

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
