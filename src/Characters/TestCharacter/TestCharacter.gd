extends Player


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var ANIMATION = $AnimationTree.get("parameters/playback")
#onready var SPRITE = $Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready():
	# getting reference and created instance of projectile
	$Projectile.connect("test_signal", self, "test_signal_receive")
	pass # Replace with function body.

func _physics_process(delta):
#	$Projectile.global_transform.origin = global_transform.origin
#	global_transform.origin = $Projectile.global_transform.origin
#	calculate_movement()
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
