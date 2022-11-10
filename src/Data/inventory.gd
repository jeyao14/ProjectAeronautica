extends Node

var path = "res://Data/partyinventory.json"

var inventory_data = {
	"player1":{
		"mod" :"null"
	}
	"player2"{
		"mod":"null"
	}
	"player3"{
		"mod":"null"
	}
	"party"{
		"items" : []
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://Data/partyinventory.json", File.READ)
	var json = JSON.parse(file.get_as_text())
	file.close()
	inventory = json.result
	
