extends Spatial

onready var LABEL = $Label
onready var AP = $AnimationPlayer
onready var TWEEN = $Tween

# Called when the node enters the scene tree for the first time.
func ready():
	pass
	
func set_values(value, start_pos):
#	self.transform.origin = start_pos
	LABEL.text = value as String
	self.global_transform.origin = start_pos
	var end_pos = Vector3(rand_range(-2, 2), rand_range(0.5, 2), rand_range(-2, 2)) + translation
	
	var tween_length = AP.get_animation("ShowDamage").length
	TWEEN.interpolate_property(self, "translation", translation, end_pos, tween_length, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TWEEN.start()
	
