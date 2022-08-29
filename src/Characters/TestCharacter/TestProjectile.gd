extends Area


export var direction = Vector3.FORWARD
export var speed = 30
export var damage = 10

onready var movement_vector = direction * speed

signal test_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func _physics_process(delta):
	self.translation += movement_vector * delta
	pass


func _on_Projectile_area_entered(area):
	emit_signal("test_signal")
	queue_free()


func _on_Projectile_body_entered(body):
	if body is Enemy:
		body.hurt_enemy(damage)
	queue_free()
