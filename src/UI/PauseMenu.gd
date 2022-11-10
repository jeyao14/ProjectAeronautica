extends Control


func _ready():
	self.visible = false
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("pause"):
		GLOBALS.paused = !GLOBALS.paused
		self.visible = GLOBALS.paused


func _on_Resume_pressed():
	if GLOBALS:
		GLOBALS.paused = false
		self.visible = false


func _on_MainMenu_pressed():
#	get_tree().quit()
	if GLOBALS.MENUS:
		GLOBALS.MENUS.unload_game()
	


func _on_Button_pressed():
	get_tree().quit()
