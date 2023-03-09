extends Spatial


var rooms = []
var ROOM_PATHS = GLOBALS.TEST_ROOMS_V2
export var max_iterations = 100
export var room_num = 5
export var min_rooms = 10
export var area = Vector2(50, 50)
export var area_increment = 20
onready var rng = RandomNumberGenerator.new()
onready var ROOMS = $Rooms
var HALL_PATH = "res://World/DungeonGenV3/Hall.tscn"
var door_positions = []
var iteration = 0
var room_count = 0

var matrix = []
var matrix_size = Vector2(0, 0)

var room_location = []
var vertex = {} #first index: node_id // second index = 0:room_location, 1:room type
var edges = []
var graph = []

var path = []

signal rooms_spawned()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	# sets init size of room matrix
	matrix_size = area
	for x in range(area.x):
		matrix.append([])
		for y in range(area.y):
			matrix[x].append("0")
	place_spawn()
	place_boss()
	place_rooms()
	
	triangulate()
	
	draw_debug()
	DebugDraw.debug_enabled = true
	pass # Replace with function body.
	

# This function generates a random number of rooms inside of a given area.
# The number of rooms is determined by the 'num_rooms' parameter, and the area is defined by the 'area'
# parameter, which should be a Vector3 representing the minimum and maximum x, y, and z coordinates of the area.
# The function returns a list of the generated rooms.
func place_rooms():
	iteration += 1
	# Generate rooms until the minimum number of rooms is reached, the specified number of rooms has been generated,
	# or the maximum number of iterations has been reached.
	var iter = 2;
	while iter < room_num:
		place_room()
		iter += 1
	
	# to-do: add check to see if total number of children in $Rooms is >= min_rooms
	# if not, run place_rooms again until min_room quota has been met
	# additionally, each new iteration of place_rooms, increase matrix size and area in case original area is too small
	
	if ROOMS.get_child_count() < min_rooms and iteration < max_iterations:
		place_rooms()
#	else:
#		path = find_mst()

func place_spawn():
	var spawn_room = load(GLOBALS.SPAWN_ROOM).instance();
	randomize_loc(spawn_room)

func place_boss():
	var boss_room = load(GLOBALS.BOSS_ROOM).instance();
	randomize_loc(boss_room)

func place_room():
	if iteration >= max_iterations:
		return
	
	rng.randomize()
	var rand_index = rng.randi_range(0, len(ROOM_PATHS) - 1)
	print("rand_index: ", rand_index)
	var selected_room = load(ROOM_PATHS[rand_index]).instance()
	# Choose a random position for the room within the given area.
	randomize_loc(selected_room)
	
func randomize_loc(selected_room):
	var size = selected_room.room_size
	
	var mid_size = size/2
	var mid_size_int = Vector2(int(size.x)/2, int(size.y)/2)
	
	
	# gets random top left coordinate
	var rand_x = rng.randi_range(mid_size_int.x, ((matrix_size.x - 1) - mid_size_int.x))
	rng.randomize()
	var rand_y = rng.randi_range(mid_size_int.y, ((matrix_size.y - 1) - mid_size_int.y))
	
	if(int(size.x) % 2 != 0) :
		rand_x += .5
		
	if(int(size.y) % 2 != 0):
		rand_y += .5
	var coord = Vector2(rand_x - mid_size.x, rand_y - mid_size.y)
	
#	print("SIZE: ", size)
#	print("MID_SIZE : ", mid_size)
#	print("COORD : ", coord)
	if grid_occupied(coord, size):
		return	
	
	var global_pos = Vector3(5*(coord.x + mid_size.x), 0,  5*(coord.y + mid_size.y))
	selected_room.translate(global_pos)
	
	for i in range(coord.x, coord.x + size.x):
		for j in range(coord.y, coord.y + size.y):
#			matrix[i][j] = "room"
			matrix[i][j] = "room"
#			print("[ ", i, " , ", j, " ]")
	ROOMS.add_child(selected_room)
	room_location.append(selected_room.global_translation)
	var room_data = []
	room_data.append(selected_room.global_translation)
	room_data.append(selected_room.type)
	vertex[room_count] = room_data
	room_count += 1;
	print("vertex[", room_count, "]: ",vertex[room_count-1])
	
func grid_occupied(coord, size):
	var xtest = -1
	for i in range(coord.x - 1, (coord.x + size.x) + 1):
		xtest += 1
		var ytest = -1
		for j in range(coord.y - 1, (coord.y + size.y) + 1):
			ytest += 1
			if (i < matrix_size.x - 1 and i >= 0) and (j < matrix_size.y - 1 and j >= 0):
				if matrix[i][j] != "0":
					return true
	return false

func draw_debug():
	var connections = []
	if graph:
		for g in graph.get_points():
			for h in graph.get_point_connections(g):
#				print(p, " ", c)
				var gp = graph.get_point_position(g);
				var hp = graph.get_point_position(h);
#				print(pp, " : ", cp)
#				if not c in connections:
#					carve_path(pp, cp)
				DebugDraw.draw_line(gp, hp, Color(0,0,1),1000000000000)
				
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
#				print(p, " ", c)
				var pp = path.get_point_position(p);
				var cp = path.get_point_position(c);
#				print(pp, " : ", cp)
				if not c in connections:
					carve_path(pp, cp)
				DebugDraw.draw_line(pp, cp, Color(1,0,0),1000000000000)
			connections.append(p)

#func find_mst():
##	var nodes = door_positions
#	var distant = []
#
#	path = AStar.new()
#	path.add_point(path.get_available_point_id(), room_location.pop_front())
#
#	while room_location:
#		var min_dist = INF
#		var min_pos = null
#		var curr_pos = null
#
#		for p1 in path.get_points():
#				p1 = path.get_point_position(p1)
#
#				for p2 in room_location:
#					if p1.distance_to(p2) < min_dist:
#						min_dist = p1.distance_to(p2)
#						min_pos = p2
#						curr_pos = p1
#
#
#		var n = path.get_available_point_id()
#		path.add_point(n, min_pos)
#		path.connect_points(path.get_closest_point(curr_pos), n)
#		room_location.erase(min_pos)
#	return path

func carve_path(pos1, pos2):
#	print("POS1 : ", pos1)
#	print("POS2 : ", pos2)
#	print("")
#	print("POS : ", pos1)
#	if pos1.x - int(pos1.x) != 0:
#		pos1.x -= 2.5
#	if pos1.z - int(pos1.z) == 0:
#		pos1.z -= 2.5
#	print("POST_POS : ", pos1)
#	if pos2.x - int(pos2.x) == 0:
#		pos2.x -= 2.5
#	if pos2.z - int(pos2.z) == 0:
#		pos2.z -= 2.5
	# Create path between two points
	var x_diff = sign(pos2.x - pos1.x) * 5
	var z_diff = sign(pos2.z - pos1.z) * 5
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if z_diff == 0: z_diff = pow(-1.0, randi() % 2)
	
	# Choose x => z OR z => x
	var x_z = pos1
	var z_x = pos2
	if (randi() % 2) > 0:
		x_z = pos2
		z_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		# add hallway to grid using x_z
		# ex: Map.set_cell(x, x_z, 0)
#		print("x : ", x)
		place_hallway(Vector2(x, x_z.z))
	for z in range(pos1.z, pos2.z, z_diff):
		# add hallway to grid using z_x
		place_hallway(Vector2(z_x.x, z))

func place_hallway(position):
	
#	size is 4 x 4
#	position -= 2.5
#	grid_cell = matrix[int(position/5)][int(position/5]
	if position.x - int(position.x) == 0:
		position.x -= 2.5
	if position.y - int(position.y) == 0:
		position.y-= 2.5
	
	var instance = load(HALL_PATH).instance()
	var size = instance.room_size
	var grid_cell = matrix[int(position.x/5)][int(position.y/5)]
	if grid_cell != "0":
		return
	
#	print(position)
	# Cell is empty and a hallway can be placed
	grid_cell = "hall"
#	var instance = load(HALL_PATH).instance()
	var mid_size = instance.room_size
	instance.global_translation = Vector3(position.x, 0, position.y)
	ROOMS.add_child(instance)
	
	pass

func triangulate():
	var vertices:PoolVector2Array = [];
	for r in vertex:
		vertices.append(Vector2(vertex[r][0].x, vertex[r][0].z))
	var triangles : PoolIntArray = Geometry.triangulate_delaunay_2d(vertices);
	
	for triangle_index in range(0,triangles.size()):
		if triangle_index % 3 != 0:
			continue
#		var point0 = Vector3(vertex[triangles[triangle_index]].x, 0, vertex[triangles[triangle_index]].z)
#		var point1 = Vector3(vertex[triangles[triangle_index+1]].x, 0, vertex[triangles[triangle_index+1]].z)
#		var point2 = Vector3(vertex[triangles[triangle_index+2]].x, 0, vertex[triangles[triangle_index+2]].z)
		if(!edges.has(Vector2(triangles[triangle_index], triangles[triangle_index+1]))):
			edges.append(Vector2(triangles[triangle_index], triangles[triangle_index+1]))
		if(!edges.has(Vector2(triangles[triangle_index+1], triangles[triangle_index+2]))):
			edges.append(Vector2(triangles[triangle_index+1], triangles[triangle_index+2]))
		if(!edges.has(Vector2(triangles[triangle_index], triangles[triangle_index+2]))):
			edges.append(Vector2(triangles[triangle_index], triangles[triangle_index+2]))
	
	create_graph()

func create_graph():
	graph = AStar.new()
	for e in edges:
		if(!graph.has_point(e.x)):
			graph.add_point(e.x, vertex[e.x as int][0])
		if(!graph.has_point(e.y)):
			graph.add_point(e.y, vertex[e.y as int][0]);
		graph.connect_points(e.x, e.y)
	path_hallways()

func path_hallways():
#	var nodes = door_positions
	
	path = AStar.new()
	rng.randomize()
	
	var start = graph.get_points()
	var start_point = rng.randi_range(0, start.size()-1)
	path.add_point(start_point, graph.get_point_position(start_point))
	start.pop_at(start_point)
	print("start_point: ", start_point)
	print("start: ", start)
	
	while start:
		var min_dist = INF
		var min_pos = null
		var curr_pos = null
		var min_id = null
		var curr_id = null

		for p1 in path.get_points():
			var p1_c = graph.get_point_connections(p1)
			var p1_p = graph.get_point_position(p1)
			print("p1: ", p1)
			print("p1_c:", p1_c)
			for p2 in p1_c:
				if !path.has_point(p2):
					var p2_p = graph.get_point_position(p2)
					if p1_p.distance_to(p2_p) < min_dist:
						print("p2: ", p2)
						min_dist = p1_p.distance_to(p2_p)
						min_pos = p2_p
						min_id = p2
						curr_id = p1;

#		print("min_id: ", min_id, " min_pos:", min_pos)
#		print("curr_id: ", curr_id, " curr_pos:", curr_pos)
		path.add_point(min_id, min_pos)
		path.connect_points(curr_id, min_id)
		start.erase(min_id)
		print("erased:", min_id, " start: ", start)
		
	for p in graph.get_points():
		var edges = graph.get_point_connections(p)
		for e in edges:
			if path.are_points_connected(p, e):
				continue;
			rng.randomize()
			if rng.randf_range(0,1) < 0.125:
				path.connect_points(p, e)

	return path
