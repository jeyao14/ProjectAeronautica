extends Bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_vector = direction.rotated(Vector3.UP, self.rotation.y) * speed
	rotation_degrees.y = angle
	pass # Replace with function body.


func _physics_process(delta):
	self.translation += movement_vector * delta
	if max_distance > 0.0:
		distance_traveled()
	pass

func distance_traveled():
	if global_transform.origin.distance_to(start_position) > max_distance:
		queue_free()

func _on_Projectile_area_entered(area):
	emit_signal("test_signal")
	queue_free()


func _on_Projectile_body_entered(body):
	if body is Enemy:
		body.hurt_enemy(damage)
		pass
	queue_free()
