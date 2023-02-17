extends Spatial


var rooms = []
var ROOM_PATHS = GLOBALS.TEST_ROOMS_V2
export var max_iterations = 10000
export var room_num = 15
export var min_rooms = 5
export var area = Vector2(20, 20)
onready var rng = RandomNumberGenerator.new()
onready var ROOMS = $Rooms
var door_positions = []
var iteration = 0

var matrix = []


signal rooms_spawned()
# Called when the node enters the scene tree for the first time.
func _ready():
	# sets init size of room matrix
	for x in range(area.x):
		matrix.append([])
		for y in range(area.y):
			matrix[x].append("0")
	
#	$CharacterSpawnPoint.global_transform.origin = $Rooms/SpawnRoom.get_node("CharacterSpawnPoint").global_transform.origin
	place_rooms(room_num)
	pass # Replace with function body.
	

# This function generates a random number of rooms inside of a given area.
# The number of rooms is determined by the 'num_rooms' parameter, and the area is defined by the 'area'
# parameter, which should be a Vector3 representing the minimum and maximum x, y, and z coordinates of the area.
# The function returns a list of the generated rooms.
func place_rooms(spawn_count):
	# Generate rooms until the minimum number of rooms is reached, the specified number of rooms has been generated,
	# or the maximum number of iterations has been reached.
	for i in room_num:
		place_room()
	
	# to-do: add check to see if total number of children in $Rooms is >= min_rooms
	# if not, run place_rooms again until min_room quota has been met
	# additionally, each new iteration of place_rooms, increase matrix size and area in case original area is too small
	emit_signal("rooms_spawned")
	

func place_room():
	if iteration >= max_iterations:
		return
	
	rng.randomize()
	var rand_index = rng.randi_range(0, len(ROOM_PATHS) - 1)
	var selected_room = load(ROOM_PATHS[rand_index]).instance()
	# Choose a random position for the room within the given area.
	
	rng.randomize()
	var size = selected_room.room_size
	print("SIZE : ", size)
	# gets random top left coordinate
	var rand_x = rng.randi_range(0, ((area.x - 1) - size.x))
	rng.randomize()
	var rand_y = rng.randi_range(0, ((area.y - 1) - size.y))
	var coord = Vector2(rand_x, rand_y)
	print("INIT COORD : ", coord.x, " , ", coord.y)
	
	if grid_occupied(coord, size):
		return
	
	selected_room.translate(Vector3(5*coord.x, 0,  5*coord.y))
	
	for i in range(coord.x, coord.x + size.x):
		for j in range(coord.y, coord.y + size.y):
			matrix[i][j] = "room"
#			print("[ ", i, " , ", j, " ]")
	
	ROOMS.add_child(selected_room)
#	$CharacterSpawnPoint.global_translate(selected_room.global_translation)
	print("created room at: ", coord.x, ", ", coord.y)
	
#	var position = Vector3(stepify(rand_range(-area.x, area.x), 5), 0, stepify(rand_range(-area.y, area.y), 5))
#	rng.randomize()
#	var rotation = Vector3(0, rng.randi_range(0, 3) * 90, 0)
#	# Create the room node and add it to the list of rooms.
#	var room = selected_room.instance()
#	room.translation = position
#	room.rotation_degrees = rotation
##	room.connect("room_destroyed", self, place_room())
#	ROOMS.add_child(room)
#
#	# Increment the iteration count.
#	iteration += 1
#	print(ROOMS.get_child_count());
	
func grid_occupied(coord, size):
#	var new_coord = coord
#	var new_size = size
#	if coord.x > 0:
#		new_coord.x = coord.x - 1
#	if coord.y > 0:
#		new_coord.y = coord.y - 1
#	if coord.x + size.x < area.x - 1:
#		new_size.x = size.x + 1
#	if coord.y + size.y < area.y - 1:
#		new_size.y = size.y + 1
	
	for i in range(coord.x - 1, (coord.x + size.x) + 1):
		for j in range(coord.y - 1, (coord.y + size.y) + 1):
			if (i < area.x and i >= 0) and (j < area.y and j >= 0):
				if matrix[i][j] != "0":
					return true
	return false

func _on_level_rooms_spawned():
	yield(get_tree().create_timer(2), "timeout")
	print("finished rooms")
	var room_count = ROOMS.get_child_count()
	if room_count < min_rooms:
		print("need more rooms")
		area += Vector2(20, 20)
#		area *= 2
		place_rooms(room_count + min_rooms)
	else:
		print("Area Size: ", area)
		if $CharacterHandler != null:
			return
		var debug_char = load(GLOBALS.HANDLER).instance()
		self.add_child(debug_char)
		debug_char.global_transform.origin = $CharacterSpawnPoint.global_transform.origin
		debug_char.debug_mode = true
		
#		store_door_positions()
		
		
		pass # Replace with function body.

func store_door_positions():
	for room in ROOMS.get_children():
		for door in room.DOORS:
			door_positions.append(door.global_translation)
	pass

func find_mst():
	var nodes = door_positions
	
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF
		var min_pos = null
		var curr_pos = null
		
		for p1 in path.get_points():
				p1 = path.get_point_position(p1)
				
				for p2 in nodes:
					if p1.distance_to(p2) < min_dist:
						min_dist = p1.distance_to(p2)
						min_pos = p2
						curr_pos = p1
		var n = path.get_available_point_id()
		path.add_point(n, min_pos)
		path.connect_points(path.get_closest_point(curr_pos), n)
		nodes.erase(min_pos)
	return path

func create_halls():
	pass