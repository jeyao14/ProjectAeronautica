extends HBoxContainer

onready var NAME = $PanelContainer/VBoxContainer/Name
onready var TEXT = $PanelContainer/VBoxContainer/Text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_values(name, text):
#	self.transform.origin = start_pos
	NAME.text = name as String
	TEXT.text = text as String

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
