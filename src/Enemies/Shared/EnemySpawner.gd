extends Spatial


export var enemy_path = "res://Enemies/TestEnemy/TestEnemy.tscn"

var ENEMY = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ENEMY = load(enemy_path)
	var instance = ENEMY.instance()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
