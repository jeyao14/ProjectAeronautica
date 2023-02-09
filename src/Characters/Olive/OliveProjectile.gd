extends Bullet

#var movement_vector = direction * speed
var status_duration = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
#	movement_vector = direction.rotated(Vector3.UP, self.rotation.y) * speed
#	rotation_degrees.y = angle
	pass # Replace with function body.

func _physics_process(delta):
	standard_translate(delta)

func distance_traveled():
	if global_transform.origin.distance_to(start_position) > max_distance:
		queue_free()


func _on_Projectile_area_entered(area):
	if area is Enemy or area is World:
#		if area.STATUS_HANDLER and stun:
#			area.STATUS_HANDLER.stun()
#		elif area.STATUS_HANDLER and slow:
#			area.STATUS_HANDLER.slow()
		if area.STATUS_HANDLER:
			match(status):
				"stun":
					area.STATUS_HANDLER.stun()
				"slow":
					area.STATUS_HANDLER.slow(status_duration)
				_:  
					# no valid string is passed
					pass
			emit_signal("test_signal")
			queue_free()


func _on_Projectile_body_entered(body):
	if body is Enemy or body is World:
		if body.STATUS_HANDLER:
			match(status):
				"stun":
					body.STATUS_HANDLER.stun()
				"slow":
					body.STATUS_HANDLER.slow(status_duration)
				_:  
					# no valid string is passed
					pass
			body.hurt_enemy(damage)
			emit_signal("test_signal")
			queue_free()
