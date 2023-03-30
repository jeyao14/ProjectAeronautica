extends Spatial


var rooms = []

var ROOM_PATHS = GLOBALS.TEST_ROOMS_V2
export var max_iterations = 100
export var room_num = 20
export var min_rooms = 10
export var area = Vector2(35, 35)
export var area_increment = 20
onready var rng = RandomNumberGenerator.new()
onready var ROOMS = $Rooms
onready var WALLS = $Walls

var HALL_PATH = "res://World/DungeonGenV3/Hall.tscn"
var WALL_PATH = "res://World/DungeonGenV3/Wall.tscn"
var GRID_WALL_PATH = "res://World/DungeonGenV3/GridWall.tscn"
var door_positions = []
var iteration = 0
var room_count = 0

var matrix = []
var matrix_size = Vector2(0, 0)

var room_location = []
var vertex = {} #first index: node_id // second index = 0:room_location, 1:room type, 2+ = hallway nodes
var edges = []
var graph = []

var grid = []
#RIGHT, UP, LEFT, DOWN
var offsets = [Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1)]
var path = []

signal rooms_spawned()
# Called when the node enters the scene tree for the first time.
func _ready():
	var WALL = load(WALL_PATH)
	
	# sets init size of room matrix
	matrix_size = area
	for x in range(area.x):
		matrix.append([])
		for y in range(area.y):
			matrix[x].append("0")
			var instance = WALL.instance()
			instance.location = Vector2(x, y)
			instance.translation = Vector3(x*5, instance.translation.y, y*5)
			WALLS.add_child(instance)
		
	place_spawn()
	place_boss()
	place_rooms()
#	place_odd_even()
	triangulate()
	create_grid()
	
	pathfind_hallways()
#	draw_debug()
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
	var iter = 0;
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

func place_odd_even():
	var selected_room = load(ROOM_PATHS[0]).instance()
	randomize_loc(selected_room)
	selected_room = load(ROOM_PATHS[2]).instance()
	randomize_loc(selected_room)
	selected_room = load(ROOM_PATHS[0]).instance()
	randomize_loc(selected_room)

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
	
	for i in range(coord.x-1, coord.x + size.x+1):
		for j in range(coord.y-1, coord.y + size.y+1):
#			matrix[i][j] = "room"
			if(i < 0 || j < 0 || i > area.x-1 || j > area.y-1):
				continue;
			if(i == coord.x-1 || j == coord.y-1 || i == coord.x + size.x || j == coord.y + size.y):
				matrix[i][j] = "border"
				remove_wall(Vector2(i, j))
				var instance = load(GRID_WALL_PATH).instance()
				instance.location = Vector2(i, j)
				instance.translation = Vector3(i*5, instance.translation.y, j*5)
				WALLS.add_child(instance)
				continue
			matrix[i][j] = "room"
			remove_wall(Vector2(i, j))
#			print("[ ", i, " , ", j, " ]")
	ROOMS.add_child(selected_room)
	print(selected_room.type)
	room_location.append(selected_room.global_translation)
	var room_data = []
	room_data.append(selected_room.global_translation)
	room_data.append(selected_room.type)
	var room_cell_center = Vector2(int(room_data[0].x/5), int(room_data[0].z/5))
	room_data.append(room_cell_center)
	vertex[room_count] = room_data
#	print("vertex[", room_count, "]: ",vertex[room_count])
	room_count += 1;
	
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
					carve_path(pp, cp, p, c)
				DebugDraw.draw_line(pp, cp, Color(1,0,0),1000000000000)
			connections.append(p)
			
func create_grid():
	grid = AStar.new()
	var weight;
	for i in matrix.size():
		for j in matrix[i].size():
			var coord = Vector2(i,j)
			var id = coord_to_id(coord, area)
			match matrix[i][j]:
				"room":
					weight = 10
				"border":
					weight = 20
				_:
					weight = 5
					
			if !grid.has_point(id):
				grid.add_point(id, Vector3(i*5, 5, j*5), weight)
				
#				print("grid weight: ", grid.get_point_weight_scale(id))
			for offset in offsets:
				var adjacent = coord + offset
				if adjacent.x >= area.x or adjacent.y >= area.x or adjacent.x < 0 or adjacent.y < 0:
					continue; 
				var adjacent_id = coord_to_id(adjacent, area)
				match matrix[adjacent.x][adjacent.y]:
					"room":
						weight = 10
					"border":
						weight = 20
					_:
						weight = 5
				
				if !grid.has_point(adjacent_id):
					grid.add_point(adjacent_id, Vector3(adjacent.x*5,5,adjacent.y*5), weight)
#				print("grid weight offset: ", grid.get_point_weight_scale(adjacent_id))
				if !grid.are_points_connected(adjacent_id, id):
					grid.connect_points(adjacent_id, id, true)
	
#	if grid:
#		for g in grid.get_points():
#			for h in grid.get_point_connections(g):
#				var gp = grid.get_point_position(g);
#				var hp = grid.get_point_position(h);
#				DebugDraw.draw_line(gp, hp, Color(0,0,1),1000000000000)


func coord_to_id(coord:Vector2, size:Vector2):
	return int(coord.x)+int(coord.y) * int(size.x)
 
func id_to_coord(id:int, size:Vector2):
	var y:int = int(id / size.x+1)
	var x:int = id % int(size.x+1)
	return Vector2(x,y)
	
func check_connectivity():
	pass

func pathfind_hallways():
	var paths = AStar.new()
	if path:
		for p in path.get_points():
			for c in path.get_point_connections(p):
#				print(p, " ", c)
				var p_matrix_pos = vertex[p][2]
				var c_matrix_pos = vertex[c][2]
#				print("p_matrix_pos: ", p_matrix_pos, " c_matrix_pos: ", c_matrix_pos)
#				print(pp, " : ", cp)
				var p_id = coord_to_id(Vector2(p_matrix_pos.x, p_matrix_pos.y), area)
				var c_id = coord_to_id(Vector2(c_matrix_pos.x, c_matrix_pos.y), area)
				var found_path = grid.get_point_path(p_id, c_id)
#				print(found_path)
				for f in found_path:
					var f_id = coord_to_id(Vector2(f.x/5,f.z/5), area)
					print("f: ", f, ", f_id: ", f_id, " f_pos: ", grid.get_point_position(f_id))
					print("weight: ", grid.get_point_weight_scale(f_id))
					print(matrix[f.x/5][f.z/5])
					if(matrix[f.x/5][f.z/5] != "room"):
						print("not a room")
						grid.set_point_weight_scale(f_id, 1)
						matrix[f.x/5][f.z/5] = "hallway"
						var instance = load(HALL_PATH).instance()
						instance.global_translation = Vector3(f.x+2.5, 0, f.z+2.5)
						remove_wall(Vector2(int(f.x/5), int(f.z/5)))
						ROOMS.add_child(instance)
#				print("p:", p_matrix_pos, ", c: ", c_matrix_pos, ", p_id: ", p_id, ", c_id: ", c_id)
#				path.disconnect_points(p, c)

func carve_path(pos1, pos2, p_id, c_id):
	if fmod(pos1.x, 5) == 0:
		pos1.x -= 2.5
	if fmod(pos1.z, 5) == 0:
		pos1.z -= 2.5
	if fmod(pos2.x, 5) == 0:
		pos2.x -= 2.5
	if fmod(pos2.z, 5) == 0:
		pos2.z -= 2.5

	# Create path between two points
	var x_diff : float = sign(pos2.x - pos1.x) * 5.0
	var z_diff : float = sign(pos2.z - pos1.z) * 5.0
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if z_diff == 0: z_diff = pow(-1.0, randi() % 2)
	
	# Choose x => z OR z => x
	var x_z = pos1
	var z_x = pos2
	if (randi() % 2) > 0:
		x_z = pos2
		z_x = pos1
	
	
	var x = pos1.x
#	for i in range(pos1.x, pos2.x)
	var rounds_x = int(abs(pos2.x - pos1.x)/5)
	for i in range(0,rounds_x):
		var diff = i * x_diff;
		# add hallway to grid using x_z
		# ex: Map.set_cell(x, x_z, 0)
		place_hallway(Vector2(pos1.x+diff, x_z.z))
#		x += x_diff
#	var z = pos1.z
#	while z <= pos2.z:
	var rounds_z = int(abs(pos2.z - pos1.z)/5)
	for j in range(0,rounds_z):
		var diff = j * z_diff;
		# add hallway to grid using z_x
		place_hallway(Vector2(z_x.x, pos1.z+diff))


func place_hallway(position):
	var instance = load(HALL_PATH).instance()
	var size = instance.room_size
	var grid_cell = matrix[int(position.x/5)][int(position.y/5)]
	if grid_cell != "0":
		return
	
	remove_wall(Vector2(int(position.x/5), int(position.y/5)))
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
		
#	print("graph: ", graph.get_points())
	path_hallways()

func path_hallways():
#	var nodes = door_positions
	
	path = AStar.new()
	rng.randomize()
	
	var start = graph.get_points()
	var start_point
	var end_point
	for s in start:
		if vertex[s][1] == "spawn":
			print("spawn room node: ", s)
			start_point = s;
		if vertex[s][1] == "boss":
			end_point = s;
	path.add_point(start_point, graph.get_point_position(start_point))
	start.erase(start_point)
	
	while start:
		var min_dist = INF
		var min_pos = null
		var curr_pos = null
		var min_id = null
		var curr_id = null

		for p1 in path.get_points():
			if(vertex[p1][1] == "boss"):
				continue
			var p1_c = graph.get_point_connections(p1)
			var p1_p = graph.get_point_position(p1)
			for p2 in p1_c:
				if !path.has_point(p2):
					if vertex[p2][1] == "boss":
						if vertex[p1][1] == "spawn":
							continue
						if start.size() > 1:
							continue;
					var p2_p = graph.get_point_position(p2)
					if p1_p.distance_to(p2_p) < min_dist:
						min_dist = p1_p.distance_to(p2_p)
						min_pos = p2_p
						min_id = p2
						curr_id = p1;

#		print("min_id: ", min_id, " min_pos:", min_pos)
#		print("curr_id: ", curr_id, " curr_pos:", curr_pos)
		path.add_point(min_id, min_pos)
		path.connect_points(curr_id, min_id, false)
		start.erase(min_id)
	
	#12.5% chance of adding unused connections to path	
	for p in graph.get_points():
		if vertex[p][1] == "boss" or vertex[p][1] == "spawn":
			continue
		var edges = graph.get_point_connections(p)
		for e in edges:
			if path.are_points_connected(p, e):
				continue;
			if vertex[e][1] == "boss" or vertex[e][1] == "spawn":
				continue
			rng.randomize()
			if rng.randf_range(0,1) < 0.125:
				path.connect_points(p, e, false)
				
#	var boss_connections = path.get_point_connections(end_point)
#	if(boss_connections.size() == 0):
#		var pot_connect = graph.get_point_connections(end_point)
#		var boss_loc = graph.get_point_position(end_point)
#		var min_dist = INF
#		var min_pos = null
#		var min_id = null
#		for c in pot_connect:
#			if boss_loc.distance_to(graph.get_point_position(c)) < min_dist:
#				if vertex[c][1] == "spawn":
#					continue
#				min_dist = boss_loc.distance_to(graph.get_point_position(c))
#				min_pos = graph.get_point_position(c)
#				min_id = c
##
#		path.connect_points(min_id, end_point)


	return path

func remove_wall(grid_position):
	for wall in WALLS.get_children():
		if wall.location == grid_position:
			print(wall.location,  " ", grid_position)
			wall.queue_free()
	pass
