extends CenterContainer

onready var CHARICON = $PartyButton/Texture
var char_data;

signal load_char_data(data)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
	
func get_data(data):
	char_data = data

func set_icon(icon):
	var image = load(icon)
	CHARICON.set_texture(image);

func _on_PartyButton_pressed():
	emit_signal("load_char_data", char_data)
	print("button pressed")

