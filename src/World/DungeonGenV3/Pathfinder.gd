extends Reference

class_name Pathfinder

const DIRECTIONS = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]

var _grid: Resource
onready var astar = AStar.new()

func _init(grid, walkable_cells: Array) -> void:
	_grid = grid;
	
	var cell_mappings = {}
	for cell in walkable_cells:
		cell_mappings[cell] = _grid.as_index(cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
