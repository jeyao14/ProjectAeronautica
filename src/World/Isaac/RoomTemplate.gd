extends Spatial
class_name Room_Template

export var room_size = Vector2(100, 100)

export var top_door = true
export var bot_door = true
export var right_door = false
export var left_door = false

var grid_coord = Vector2.ZERO

onready var TOP_WALL = $Navigation/TopWall
onready var BOT_WALL = $Navigation/BotWall
onready var RIGHT_WALL = $Navigation/RightWall
onready var LEFT_WALL = $Navigation/LeftWall

func _ready():
	setup_walls()
	move_to_grid_coord()


func setup_walls():
	if top_door:
		TOP_WALL.get_node("Wall").queue_free()
	else:
		TOP_WALL.get_node("DoorWall").queue_free()
	
	if bot_door:
		BOT_WALL.get_node("Wall").queue_free()
	else:
		BOT_WALL.get_node("DoorWall").queue_free()
	
	if right_door:
		RIGHT_WALL.get_node("Wall").queue_free()
	else:
		RIGHT_WALL.get_node("DoorWall").queue_free()
	
	if left_door:
		LEFT_WALL.get_node("Wall").queue_free()
	else:
		LEFT_WALL.get_node("DoorWall").queue_free()

func move_to_grid_coord():
	self.translation = Vector3(grid_coord.x * room_size.x, 0, grid_coord.y * room_size.y)
