extends Spatial

onready var NAME = $Viewport/Control/Panel/InteractionContainer/Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_values(var text):
#	self.transform.origin = start_pos
	NAME.text = text as String
