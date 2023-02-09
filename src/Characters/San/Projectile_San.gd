extends Bullet

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
	if area is Bullet:
		if area:
			bullet_reflect(area)
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
					area.STATUS_HANDLER.slow()
				_:  
					# no valid string is passed
					pass
			emit_signal("test_signal")

func _on_Projectile_body_entered(body):
	if body is Bullet:
		if body:
			bullet_reflect(body)
	if body is Enemy or body is World:
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
			emit_signal("test_signal")

func bullet_reflect(target):
		target.set_collision_layer_bit(3, true)
		target.set_collision_layer_bit(7, false)
		target.set_collision_mask_bit(0, true)
		target.set_collision_mask_bit(2, true)
		target.set_collision_mask_bit(1, false)
		target.set_collision_mask_bit(3, false)
		target.reflected = true
		target.movement_vector = self.movement_vector.normalized()
		target.rotation.y = self.rotation.y
