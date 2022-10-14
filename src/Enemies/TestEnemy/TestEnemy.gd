extends Enemy

var path = []
var current_path_index = -1
var threshhold = 1

var nav_path = ""
var NAV = null
onready var TIMER = $PathTimer
onready var ATTACK_TIMER = $AttackTimer
onready var SPAWNER = $Spawner
onready var SPRITE = $Sprite3D
onready var ANIM_PLAYER = $AnimationTree.get("parameters/playback")
onready var ANIM_TREE = $AnimationTree

func _ready():
	if nav_path != "":
		NAV = get_node(nav_path)
	velocity.y = gravity
	ANIM_TREE.active = true

func _physics_process(delta):
	if GLOBALS.CHARACTER_HANDLER == null or not alive or NAV == null:
		return
	global_pos = global_transform.origin
	if path.size() > 0:
		move_to_target()
		set_facing()
	move_enemy()
	pass

func set_facing():
	# Calculates distance between player and enemy
	var relative_pos = GLOBALS.CHARACTER_HANDLER.global_transform.origin - global_pos
	# Rotates vector based on the camera rotation
	var self_to_player = relative_pos.rotated(Vector3.UP, -GLOBALS.CHARACTER_HANDLER.CAMERABOOM.rotation.y).normalized()
	
	# variable will be used to see if the facing direction of the sprite needs to be changed
	var new_facing = facing

	# If player is to the left of the enemy
	if self_to_player.x < 0:		
		facing = -1
	# If player is to the right of the enemy
	elif self_to_player.x > 0:
		facing = 1
	# If the facing changed, flip the sprite
	if new_facing != facing:
		SPRITE.flip_h = not SPRITE.flip_h

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
#		direction.y = gravity
		velocity = direction.normalized() * speed
		
#		move_and_slide(velocity, Vector3.UP)
	return

func move_enemy():
	velocity.y = gravity
	if(self.is_on_floor()):
		velocity.y = 0
	move_and_slide(velocity, Vector3.UP)

func get_player_path():
#	if GLOBALS.CHARACTER_HANDLER == null:
#		return 
	var player_pos = GLOBALS.CHARACTER_HANDLER.global_transform.origin
	player_pos.y = global_pos.y
	path = NAV.get_simple_path(global_pos, player_pos)
	current_path_index = 0
	return

func kill_enemy():
	ATTACK_TIMER.stop()
	set_physics_process(false)
	ANIM_PLAYER.travel("Death")
	pass

func attack():
	if GLOBALS.CHARACTER_HANDLER == null:
		return
	SPAWNER.mouse_direction = GLOBALS.CHARACTER_HANDLER.global_transform.origin
	SPAWNER.shoot = true
	ATTACK_TIMER.start()

func _on_Timer_timeout():
	get_player_path()
	pass # Replace with function body.


func _on_AttackTimer_timeout():
	ANIM_PLAYER.travel("Attack")
	pass # Replace with function body.
