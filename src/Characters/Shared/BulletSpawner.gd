extends Spatial


export var bullet_path = "res://Characters/TestCharacter/TestProjectile.tscn"
export(int) var burst_count = 0
var burst_timer = 0 setget set_burst_timer
var cooldown = .5 setget set_cooldown

onready var BULLET_GROUP = $BulletGroup
onready var COOLDOWN = $CooldownTimer
onready var BURST_TIMER = $BurstTimer
onready var mouse_direction = Vector3.ZERO
var BULLET
var shoot = true
var is_firing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	BULLET = load(bullet_path)
	COOLDOWN.wait_time = cooldown
	BURST_TIMER.wait_time = burst_timer
	fire()
	pass # Replace with function body.

func _physics_process(delta):
	pass


func fire():
	if not is_firing:
		is_firing = true
		if burst_count > 0 and burst_timer > 0:
			for i in burst_count:
				if not shoot:
					break
				spawn_bullet()
				BURST_TIMER.start()
				yield(BURST_TIMER, "timeout")
		else:
			spawn_bullet()
		COOLDOWN.start()
		yield(COOLDOWN, "timeout")
		is_firing = false

func spawn_bullet():
	var global_pos = self.global_transform.origin
	var angle = Vector2(global_pos.x, global_pos.z).angle_to(Vector2(mouse_direction.x, mouse_direction.z))
	print(angle)
	var instance = BULLET.instance()
	mouse_direction.y = self.global_transform.origin.y
	
	var direction_vector = (mouse_direction - self.global_transform.origin).normalized()
	
	instance.direction = direction_vector
	BULLET_GROUP.add_child(instance)
	instance.translation = self.global_transform.origin
	mouse_direction = Vector3.ZERO

func set_burst_timer(value):
	burst_timer = value
	BURST_TIMER.wait_time = burst_timer

func set_cooldown(value):
	cooldown = value
	COOLDOWN.wait_time = cooldown
