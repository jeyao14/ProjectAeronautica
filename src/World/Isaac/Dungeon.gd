extends Spatial
class_name Dungeon

export var dungeon_size = Vector2(10, 10)
export var min_encounter_rooms = 5
export var start_coord = Vector2.ZERO

onready var ROOM_NODE = $Rooms

var current_room = null
var current_coord = Vector2.ZERO
var prev_coord = Vector2.ZERO

var SPAWN_ROOM = "res://World/Isaac/SpawnRoom.tscn"

var ROOMS = [
	"res://World/Isaac/2_door/2Room1.tscn",
	"res://World/Isaac/2_door/2Room2.tscn",
	"res://World/Isaac/2_door/2Room3.tscn",
]

var DEADEND = "res://World/Isaac/1_door/1Room1.tscn"

var matrix = []
var dict := {}


# Called when the node enters the scene tree for the first time.
func _ready():
	if abs(start_coord.x) > abs(dungeon_size.x):
		start_coord.x = dungeon_size.x
	if abs(start_coord.y) > abs(dungeon_size.y):
		start_coord.y = dungeon_size.y
	
	var instance = load(SPAWN_ROOM).instance()
	instance.grid_coord = start_coord
	var arr = [start_coord]
	matrix.append(instance)
	dict[arr] = instance.grid_coord.x
	
	current_coord = start_coord
	prev_coord = start_coord
	
	current_room = instance
	instance.translation = Vector2(instance.room_size.x * instance.grid_coord.x, instance.room_size.y * instance.grid_coord.y)
	create_room(instance)

func create_room(current_room):
	# Room has been instanced, but not added to tree yet
	if current_room == null:
		return
	
	if current_room.top_door:
		var arr = dict.get(current_room.x)
		if arr == null:
			return
		var neighbor = null
		if dict.has(current_room.x - 1):
			neighbor = dict.get(current_room.x - 1)
		if arr.size() == 1 or neighbor == null:
			pick_room()
		elif not neighbor.bot_door:
			current_room.top_door = false
			
	
	# foreach door direction iterate through dictionary to find neighbors
		# for left and right, find keys that are +1 or -1 current y coordinate
			# if a key already exists at that x coord
				# if neighbor room doesn't have a connecting door, disable door for current room
					#alternatively, if neighbor has door, but current room doesn't, activate door for that side
				# regardless, don't create room in this direction
			# else, call pick_room function and instance chosen scene
			# create new array entry with new rooms coordinates and call create_room(new_instance)
		# for up and down, find key that matches x coordinate (there should be at least one matching key)
			# iterate through array and find coordinates with x == current_room.y +/-1
				# if room exists at that coordinate
					# if neighbor room doesn't have a connecting door, disable door for current room
						#alternatively, if neighbor has door, but current room doesn't, activate door for that side
					# regardless, don't create room in this direction
				# else, call pick_room function
				# create new array entry with new rooms coordinates and call create_room(new_instance)
	
	# add room
	
	pass

func pick_room():
	# check if there are more encounter rooms that need to be made
		# if so, randomely pick room from ROOMS array
		# else, Pick from DeadEnd
	pass
