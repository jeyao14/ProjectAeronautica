extends Area


export var direction = Vector3.FORWARD
export var speed = 170
export var damage = 10
export var max_distance = 100.0
export var angle = 0.0

onready var start_position = global_transform.origin

#onready var movement_vector = direction * speed
var movement_vector = direction

signal test_signal

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
