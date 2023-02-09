extends Bullet

export var speed_increment = 1.0
export var max_speed = 100.0
export var min_speed = 0

onready var init_speed = speed
var reflected = false;
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
	if speed <= min_speed:
		queue_free()
	if speed <= max_speed:
		speed += speed_increment
	
	standard_translate(delta)

func stun_player():
	if GLOBALS.CHARACTER_HANDLER == null:
		return
	var handler = GLOBALS.CHARACTER_HANDLER
	var stun = GLOBALS.STUN_STATUS_EFFECT.instance()
	handler.ACTIVE_CHARACTER.add_child(stun)

func _on_Projectile_area_entered(area):
	if reflected == false:
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
				queue_free()
	elif reflected == true:
		if area is Enemy or area is World:
#			print("reflected bullet")
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
				queue_free()


func _on_Projectile_body_entered(body):
	if reflected == false:
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
	elif reflected == true:
		if body is Enemy or body is World:
			print(speed)
			print(speed_increment)
	#		if area.STATUS_HANDLER and stun:
	#			area.STATUS_HANDLER.stun()
	#		elif area.STATUS_HANDLER and slow:
	#			area.STATUS_HANDLER.slow()
			if body.STATUS_HANDLER:
				match(status):
					"stun":
						body.STATUS_HANDLER.stun()
					"slow":
						body.STATUS_HANDLER.slow()
					_:  
						# no valid string is passed
						pass
				body.hurt_enemy(damage)
				queue_free()
