extends HBoxContainer

onready var VALUE = $Panel2/CenterContainer2/Value
onready var STAT = $Panel/CenterContainer/Stat


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func populate_values(stat, value):
	VALUE.text = value as String;
	STAT.text = stat as String;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
