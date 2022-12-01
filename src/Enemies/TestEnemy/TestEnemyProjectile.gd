extends Bullet

export var speed_increment = 1.0
export var max_speed = 100.0

onready var init_speed = speed
#onready var movement_vector = direction * speed

# Called when the node enters the scene tree for the first time.
func _ready():
#	movement_vector = direction.rotated(Vector3.UP, self.rotation.y)
#	rotation_degrees.y = angle
#	randomize()
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
	if area is Player or area is World:
#		if area.STATUS_HANDLER and stun:
#			area.STATUS_HANDLER.stun()
#		elif area.STATUS_HANDLER and slow:
#			area.STATUS_HANDLER.slow()
		if area.STATUS_HANDLER:
			match(status):
				"stun":
					area.STATUS_HANDLER.stun()
				"slow":
					area.STATUS_HANDLER.slow()
				_:  
					# no valid string is passed
					pass
			emit_signal("test_signal")
			queue_free()


func _on_Projectile_body_entered(body):
	if body is Player or body is World:
		if body.STATUS_HANDLER:
			match(status):
				"stun":
					body.STATUS_HANDLER.stun(10.0)
				"slow":
					body.STATUS_HANDLER.slow(2.0)
				_:  
					# no valid string is passed
					pass
			body.hurt_player(damage)
			emit_signal("test_signal")
			queue_free()
