extends Node

var perkdata

func _ready():
	var file = File.new()
	file.open("res://Data/perksdata - Sheet1.json", File.READ)
	var json = JSON.parse(file.get_as_text())
	file.close()
	perkdata = json.result
	print(perkdata);
	
