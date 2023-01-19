extends Control

onready var CHARGRID = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/CharGrid
onready var PARTYSLOT_1 = $MarginContainer/HBoxContainer/VBoxContainer/SelectionContainer/PartySlot_1/Button/TextureRect
onready var PARTYSLOT_2 = $MarginContainer/HBoxContainer/VBoxContainer/SelectionContainer/PartySlot_2/Button/TextureRect
onready var PARTYSLOT_3 = $MarginContainer/HBoxContainer/VBoxContainer/SelectionContainer/PartySlot_3/Button/TextureRect
onready var PARTYINFOCONTAINER = $MarginContainer/HBoxContainer/MarginContainer/PartyCharInfoContainer

var party_button = load("res://UI/PartySelection/PartyContainer.tscn")
var selection_mode = false
var selected_slot = ""
var selected_character = null
onready var data = ImportData.char_data
var char1
var char2
var char3

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false;
#	print("data ", data)
#	print(data.size())
	load_party();
#	connect_signal()
	load_characters();

func activate_screen():
	self.visible = true;
	GLOBALS.paused = true;

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
	print(selection_mode)
	if(selection_mode == false):
		selection_mode = true
		selected_slot = "1"
		selected_character = GLOBALS.MENUS.party["1"]
	elif (selection_mode == true): 
		print(selected_character)
		print(GLOBALS.MENUS.party["1"])
		if (selected_character != GLOBALS.MENUS.party["1"]):
			var temp = GLOBALS.MENUS.party["1"]
			GLOBALS.MENUS.party["1"] = selected_character
			GLOBALS.MENUS.party[selected_slot] = temp
			selection_mode = false
			GLOBALS.CHARACTER_HANDLER.reload_party()
			load_party()
		elif(selected_character == GLOBALS.MENUS.party["1"]):
			selected_slot = ""
			selected_character = null
			selection_mode = false

func _on_Party_2_pressed():
	print(selection_mode)
	if(selection_mode == false):
		selection_mode = true
		selected_slot = "2"
		selected_character = GLOBALS.MENUS.party["2"]
	elif (selection_mode == true): 
		print(selected_character)
		print(GLOBALS.MENUS.party["2"])
		if (selected_character != GLOBALS.MENUS.party["2"]):
			var temp = GLOBALS.MENUS.party["2"]
			GLOBALS.MENUS.party["2"] = selected_character
			GLOBALS.MENUS.party[selected_slot] = temp
			selection_mode = false
			GLOBALS.CHARACTER_HANDLER.reload_party()
			load_party()
		elif(selected_character == GLOBALS.MENUS.party["2"]):
			selected_slot = ""
			selected_character = null
			selection_mode = false

func _on_Party3_pressed():
	print(selection_mode)
	if(selection_mode == false):
		selection_mode = true
		selected_slot = "3"
		selected_character = GLOBALS.MENUS.party["3"]
	elif (selection_mode == true): 
		print(selected_character)
		print(GLOBALS.MENUS.party["3"])
		if (selected_character != GLOBALS.MENUS.party["3"]):
			var temp = GLOBALS.MENUS.party["3"]
			GLOBALS.MENUS.party["3"] = selected_character
			GLOBALS.MENUS.party[selected_slot] = temp
			selection_mode = false
			GLOBALS.CHARACTER_HANDLER.reload_party()
			load_party()
		elif(selected_character == GLOBALS.MENUS.party["3"]):
			selected_slot = ""
			selected_character = null
			selection_mode = false

func _on_Button_pressed():
	self.visible = false
	GLOBALS.paused = false
