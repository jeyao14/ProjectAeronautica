extends Area

var direction = Vector3.FORWARD
export var speed = 1.0
export var speed_increment = 1.0
export var max_speed = 100.0
export var damage = 10
export var max_distance = 50.0
export var stun = false
export var slow = true
var angle = 0.0

onready var start_position = global_transform.origin
onready var init_speed = speed
#onready var movement_vector = direction * speed
var movement_vector = direction

signal test_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_vector = direction.rotated(Vector3.UP, self.rotation.y)
	rotation_degrees.y = angle
	randomize()
#	if rand_range(1, 10) < 5:
#		stun = true
	pass # Replace with function body.


func _physics_process(delta):
	if speed < -init_speed:
		queue_free()
	if speed < max_speed:
		speed += speed_increment
	
	self.translation += (movement_vector * speed) * delta
	if max_distance > 0.0:
		distance_traveled()
	pass

func distance_traveled():
	if global_transform.origin.distance_to(start_position) > max_distance:
		queue_free()

func stun_player():
	if GLOBALS.CHARACTER_HANDLER == null:
		return
	var handler = GLOBALS.CHARACTER_HANDLER
	var stun = GLOBALS.STUN_STATUS_EFFECT.instance()
	handler.ACTIVE_CHARACTER.add_child(stun)

func _on_Projectile_area_entered(area):
	print("test_signal")
	if area is World:
		queue_free()
	elif area is Player:
		print("area: ", area)
		if stun:
			print("stun player")
			stun_player()
		area.hurt_player(damage)
		queue_free()


func _on_Projectile_body_entered(body):
	if body is World:
		queue_free()
	elif body is Player:
		print("body: ", body)
		if stun and body.STATUS_HANDLER:
			body.STATUS_HANDLER.stun()
		elif slow and body.STATUS_HANDLER:
			body.STATUS_HANDLER.slow()
		body.hurt_player(damage)
		queue_free()
