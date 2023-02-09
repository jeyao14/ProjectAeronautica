extends Area
class_name Bullet

var direction = Vector3.FORWARD
export var speed = 10
export var damage = 10
export var max_distance = 100.0
export var angle = 0.0
export var stun = false
export var slow = false

onready var start_position = global_transform.origin

#onready var movement_vector = direction * speed
var movement_vector = direction
var status = ""

signal test_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_vector = direction.rotated(Vector3.UP, self.rotation.y).normalized()
	rotation_degrees.y = angle
	pass # Replace with function body.
	
func standard_translate(delta):
	self.translation += (movement_vector * speed) * delta
	if max_distance > 0.0:
		distance_traveled()

func distance_traveled():
	if global_transform.origin.distance_to(start_position) > max_distance:
		queue_free()
		
func _on_Projectile_area_entered(area):
	if area is Enemy or area is World:
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
			queue_free()
