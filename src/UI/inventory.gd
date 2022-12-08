extends Control

var CHARACTER_1: Player
var CHARACTER_2: Player
var CHARACTER_3: Player

onready var CHARINFO = $MarginContainer/HBoxContainer/CharInfoMargin/CharInfoContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false;
	get_party_info(GLOBALS.CHARACTER_HANDLER.CHARACTER_1,GLOBALS.CHARACTER_HANDLER.CHARACTER_2,GLOBALS.CHARACTER_HANDLER.CHARACTER_3);
#	self.connect("open_inven", self, "toggle_visible")
	pass # Replace with function body.
	
func _input(event):
	if event.is_action_pressed("pause") and self.visible:
		self.visible = false;

func toggle_visible():
	self.visible = true;
	get_party_info(GLOBALS.CHARACTER_HANDLER.CHARACTER_1,GLOBALS.CHARACTER_HANDLER.CHARACTER_2,GLOBALS.CHARACTER_HANDLER.CHARACTER_3);

func get_party_info(char1: Player, char2: Player, char3: Player):
	self.CHARACTER_1 = char1;
	self.CHARACTER_2 = char2;
	self.CHARACTER_3 = char3;
	
	CHARINFO.populate_info(CHARACTER_1)
	

func _on_Char1_pressed():
	CHARINFO.populate_info(CHARACTER_1)


func _on_Char2_pressed():
	CHARINFO.populate_info(CHARACTER_2)

func _on_Char3_pressed():
	CHARINFO.populate_info(CHARACTER_3)
