extends Spatial


var rooms = []
var ROOM_PATHS = GLOBALS.TEST_ROOMS
export var max_iterations = 100
export var room_num = 10
export var min_rooms = 5
export var area = Vector2(100, 100)
onready var rng = RandomNumberGenerator.new()
onready var ROOMS = $Rooms
var door_positions = []
var iteration = 0

signal rooms_spawned()
# Called when the node enters the scene tree for the first time.
func _ready():
	print("HELLO")
	$CharacterSpawnPoint.global_transform.origin = $Rooms/SpawnRoom.get_node("CharacterSpawnPoint").global_transform.origin
	generate_rooms(room_num)
	pass # Replace with function body.
	

# This function generates a random number of rooms inside of a given area.
# The number of rooms is determined by the 'num_rooms' parameter, and the area is defined by the 'area'
# parameter, which should be a Vector3 representing the minimum and maximum x, y, and z coordinates of the area.
# The function returns a list of the generated rooms.
func generate_rooms(spawn_count):
	# Generate rooms until the minimum number of rooms is reached, the specified number of rooms has been generated,
	# or the maximum number of iterations has been reached.
	for i in room_num:
		generate_room()
		yield(get_tree().create_timer(0.25), "timeout")
	emit_signal("rooms_spawned")
	
	
	

func generate_room():
	if iteration >= max_iterations:
		return
	rng.randomize()
	var rand_index = rng.randi_range(0, len(ROOM_PATHS) - 1)
	var selected_room = load(ROOM_PATHS[rand_index])
	# Choose a random position for the room within the given area.
	randomize()
	var position = Vector3(stepify(rand_range(-area.x, area.x), 4), 0, stepify(rand_range(-area.y, area.y), 4))
	rng.randomize()
	var rotation = Vector3(0, rng.randi_range(0, 3) * 90, 0)
	# Create the room node and add it to the list of rooms.
	var room = selected_room.instance()
	room.translation = position
	room.rotation_degrees = rotation
#	room.connect("room_destroyed", self, generate_room())
	ROOMS.add_child(room)

	# Increment the iteration count.
	iteration += 1
	print(ROOMS.get_child_count());
	


func _on_level_rooms_spawned():
	yield(get_tree().create_timer(2), "timeout")
	print("finished rooms")
	var room_count = ROOMS.get_child_count()
	if room_count < min_rooms:
		print("need more rooms")
		area += Vector2(20, 20)
#		area *= 2
		generate_rooms(room_count + min_rooms)
	else:
		print("Area Size: ", area)
		if $CharacterHandler != null:
			return
		var debug_char = load(GLOBALS.HANDLER).instance()
		self.add_child(debug_char)
		debug_char.global_transform.origin = $CharacterSpawnPoint.global_transform.origin
		debug_char.debug_mode = true
		
		store_door_positions()
		pass # Replace with function body.

func store_door_positions():
	for room in ROOMS.get_children():
		for door in room.DOORS:
			door_positions.append(door.global_translation)
	pass
