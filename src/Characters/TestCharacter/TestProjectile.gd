extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal test_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Projectile_area_entered(area):
	emit_signal("test_signal")
	pass # Replace with function body.
