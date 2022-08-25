extends Player


func _ready():
	$Projectile.connect("test_signal", self, "test_signal_receive")
	pass # Replace with function body.

func _physics_process(delta):
	set_animation()
	set_facing()
	
func _on_HitBox_area_entered(area):
	print("AREA ENTERED")
	hurt_player()
	pass # Replace with function body.



func _on_HitBox_body_entered(body):
	print("BODY ENTERED")
	hurt_player()
	pass # Replace with function body.

func test_signal_receive():
	print("SIGNAL")


