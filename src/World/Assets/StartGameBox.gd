extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HitBox_area_entered(area):
	create_interaction();

func _on_HitBox_area_exited(area):
	clear_interaction();
