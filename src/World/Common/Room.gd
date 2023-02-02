extends Spatial
class_name Room_Node

export var spawn_active = false

export (Array, NodePath) var DOORS

var size = Vector3.ZERO

var position = Vector3.ZERO setget set_position

var locked_in = false

signal room_destroyed()
signal lock_in()

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	yield(get_tree().create_timer(.25), "timeout")
	locked_in = true
	print("Locked In")
	emit_signal("lock_in")
	pass # Replace with function body.

func set_position(value):
	position = value
	self.translation = value


func _on_Boundary_area_entered(area):
	if not spawn_active and not locked_in:
		emit_signal("room_destroyed")
		queue_free()
	pass # Replace with function body.
