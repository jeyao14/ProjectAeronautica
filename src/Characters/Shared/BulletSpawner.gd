extends Spatial


export var bullet_path = "res://Characters/TestCharacter/TestProjectile.tscn" setget set_bullet
export(int) var ammocount =  0
export var uses_ammo = true;
export var cooldown = .5 setget set_cooldown
export var full_auto = false
onready var COOLDOWN = $CooldownTimer
onready var mouse_direction = Vector3.ZERO
onready var BULLET_GROUP = $BulletGroup


# Burst Variables
export(int) var burst_count = 0
var burst_timer = .1 setget set_burst_timer
onready var BURST_TIMER = $BurstTimer

# Spread Variables
export (int) var spread_count = 0
export var spread_angle = 45.0
export var random = false

# Bullet speed override
export var bullet_speed_override = 0.0
export var bullet_speed_override_range = Vector2.ZERO

var BULLET
var shoot = false
var is_firing = false

signal update_ammo;

# Called when the node enters the scene tree for the first time.
func _ready():
	BULLET = load(bullet_path)
	print("spawner bullet path: ", bullet_path)
	COOLDOWN.wait_time = cooldown
	print("spawner cooldown: ", cooldown)
	BURST_TIMER.wait_time = burst_timer
	pass # Replace with function body.

func _physics_process(delta):
	if uses_ammo:
		if shoot and not is_firing and ammocount > 0:
			fire()
	else:
		if shoot and not is_firing and ammocount == -1:
			print("no ammo firing")
			fire()
	pass

func setShotCooldown():
	pass

func fire_cooldown():
	print("Ammo: ", ammocount)
	if not full_auto:
		shoot = false
	COOLDOWN.start()
	yield(COOLDOWN, "timeout")
	is_firing = false
	

func fire():
	if not is_firing:
		# prevent fire() from being called every frame
		is_firing = true
		
		var spread = false
		if spread_count > 0:
			spread = true
		# if burst information is set, call burst fire functionality
		if burst_count > 0 and burst_timer > 0:
			burst_fire(spread)
		# else single shot
		else:
			if spread:
				spread_fire()
				use_ammo();
			else:
				spawn_bullet()
				use_ammo();
			fire_cooldown()

func burst_fire(spread):
	for i in burst_count:
		if not shoot or not has_ammo():
			break
		if spread:
			spread_fire()
		else:
			spawn_bullet()
			use_ammo();
		BURST_TIMER.start()
		yield(BURST_TIMER, "timeout")
	fire_cooldown()

func spread_fire():
	if random:
		# gets the half angle to determine the range for the random angle
		var half_angle = spread_angle/2.0
		for i in spread_count:
			if not has_ammo():
				break
			# gets a random angle inside of the defined angle range
			randomize()
			var angle = rand_range(-half_angle, half_angle)
			spawn_bullet(angle)
	else:
		# splits the spread angle into equally distanced angles
		var angle_increment = (spread_angle/ (spread_count + 1.0))
		
		# set the starting angle to the far right side of the angle range 
		var current_angle = -(spread_angle/2) + angle_increment
		
		for i in spread_count:
			if not has_ammo():
				break
			spawn_bullet(current_angle)
			current_angle += angle_increment
	return


func spawn_bullet(angle = 0.0):
	var global_pos = self.global_transform.origin
	var instance = BULLET.instance()
	mouse_direction.y = self.global_transform.origin.y
	
	if bullet_speed_override > 0.0:
		instance.speed = bullet_speed_override
	elif bullet_speed_override_range != Vector2.ZERO:
		randomize()
		instance.speed = rand_range(bullet_speed_override_range.x, bullet_speed_override_range.y)
	
	var direction_vector = (global_pos - mouse_direction).normalized()
	# gets a direction angle based off of the direction vector + any additional angle offsets
	var direction_angle = rad2deg(atan2(direction_vector.x, direction_vector.z)) + angle
	
	
	instance.rotation_degrees.y = direction_angle
	instance.angle = direction_angle
	instance.translation = global_pos
	BULLET_GROUP.add_child(instance)
	
	
func has_ammo():
	if(ammocount == -1):
		return true;
	if(ammocount < 1):
		return false
	return true

func use_ammo():
	if(ammocount > 0):
		ammocount -= 1

func set_burst_timer(value):
	burst_timer = value
	BURST_TIMER.wait_time = burst_timer

func set_cooldown(value):
	cooldown = value
	COOLDOWN.wait_time = cooldown
	print("COOLDOWN CHANGED TO: ", COOLDOWN.wait_time)

func set_bullet(path):
	bullet_path = path;
	BULLET = load(bullet_path)
	print("PATH CHANGED TO: ", bullet_path)
