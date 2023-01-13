extends Node

var perkdata
var char_data_sheet
var char_data

func _ready():
	var file = File.new()
	file.open("res://Data/perksdata - Sheet1.json", File.READ)
	var perk_json = JSON.parse(file.get_as_text())
	file.close()
	perkdata = perk_json.result
#	print(perkdata);
	
	file.open("res://Data/CharacterStats.json", File.READ)
	var char_json = JSON.parse(file.get_as_text())
	file.close()
	char_data_sheet = char_json.result
	char_data = char_data_sheet["Sheet1"]
#	print(char_data);
	
