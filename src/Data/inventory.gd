extends Node

var path = "res://Data/partyinventory.json"

var default_inventory_data = {
	"player1":{
		"mod" :"null"
	},
	"player2":{
		"mod":"null"
	},
	"player3":{
		"mod":"null"
	},
	"party":{
		"items" : []
	},
}
var inventory_data = {
	"player1":{
		"mod" :"null"
	},
	"player2":{
		"mod":"null"
	},
	"player3":{
		"mod":"null"
	},
	"party":{
		"items" : []
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	update_game_data()
	
func load_game():
	var file = File.new()

	if not file.file_exists(path):
		reset_data()
		return
		
	file.open(path, file.READ)
	inventory_data = parse_json(file.get_as_text())
	file.close()

func save_data():
	var file
	file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(inventory_data))
	file.close()

func reset_data():
	var file
	file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json(default_inventory_data))
	file.close()

func update_game_data():
	pass
