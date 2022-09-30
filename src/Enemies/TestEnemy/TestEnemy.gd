extends Enemy

var path = []
var current_path_index = -1
var threshhold = 1
var speed = 5

onready var global_pos = self.global_transform.origin


onready var NAV = $"../../Navigation" as Navigation
onready var TIMER = $Timer

func _ready():
	
	get_player_path()

func _physics_process(delta):
	global_pos = global_transform.origin
	if path.size() > 0:
		move_to_target()
	pass

func move_to_target():
	if current_path_index < 0 or current_path_index >= path.size():
		TIMER.stop()
		get_player_path()
		TIMER.start()
		return
	
	global_pos = self.global_transform.origin
	var current_path = path[current_path_index]
	
	if global_pos.distance_to(current_path) < threshhold:
		current_path_index += 1
	else:
		var direction = current_path - global_pos
		var velocity = direction.normalized() * speed
		
		move_and_slide(velocity, Vector3.UP)
	return

func get_player_path():
	if GLOBALS.CHARACTER_HANDLER == null:
		return 
	var player_pos = GLOBALS.CHARACTER_HANDLER.global_transform.origin
	player_pos.y = global_pos.y
	path = NAV.get_simple_path(global_pos, player_pos)
	current_path_index = 0
	return


func _on_Timer_timeout():
	get_player_path()
	pass # Replace with function body.
