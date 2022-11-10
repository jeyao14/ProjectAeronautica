extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GLOBALS:
		GLOBALS.paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RestartButton_pressed():
	if GLOBALS.MENUS:
		GLOBALS.MENUS.restart_game()
	pass # Replace with function body.


func _on_QuitButton_pressed():
	if GLOBALS.MENUS:
		GLOBALS.MENUS.unload_game()
