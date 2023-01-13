extends Control

onready var CHARGRID = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/CharGrid
onready var PARTYSLOT_1 = $MarginContainer/HBoxContainer/VBoxContainer/SelectionContainer/PartySlot_1/Button/TextureRect
onready var PARTYSLOT_2 = $MarginContainer/HBoxContainer/VBoxContainer/SelectionContainer/PartySlot_2/Button/TextureRect
onready var PARTYSLOT_3 = $MarginContainer/HBoxContainer/VBoxContainer/SelectionContainer/PartySlot_3/Button/TextureRect
onready var PARTYINFOCONTAINER = $MarginContainer/HBoxContainer/MarginContainer/PartyCharInfoContainer

var party_button = load("res://UI/PartySelection/PartyContainer.tscn")
onready var data = ImportData.char_data
var char1
var char2
var char3

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("data ", data)
#	print(data.size())
#	load_party();
#	connect_signal()
	load_characters();

func connect_signal():
	
	print("signal connected")

func load_party():
	char1 = GLOBALS.CHARACTER_HANDLER.CHARACTER_1
	char2 = GLOBALS.CHARACTER_HANDLER.CHARACTER_2
	char3 = GLOBALS.CHARACTER_HANDLER.CHARACTER_3
	PARTYSLOT_1.texture = char1.CHARACTERICON
	PARTYSLOT_2.texture = char2.CHARACTERICON
	PARTYSLOT_3.texture = char3.CHARACTERICON

func load_characters():
	for c in data.keys():
		print(c)
		var char_data = get_char_data(c)
		var char_button = party_button.instance();
		CHARGRID.add_child(char_button);
		char_button.get_data(char_data)
		char_button.set_icon(char_data["CharacterIcon"]);
		char_button.connect("load_char_data", PARTYINFOCONTAINER, "populate_info")
	print("completed")

func get_char_data(name):
	return ImportData.char_data[name]

func _on_Party1_pressed():
	pass # Replace with function body.

func _on_Party_2_pressed():
	pass # Replace with function body.

func _on_Party3_pressed():
	pass # Replace with function body.
	

