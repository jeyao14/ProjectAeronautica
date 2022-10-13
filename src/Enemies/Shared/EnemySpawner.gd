extends Spatial


export var enemy_path = "res://Enemies/TestEnemy/TestEnemy.tscn"
export var nav_path = "../../Navigation"

onready var ENEMY_GROUP = $EnemyGroup
onready var SPAWN_TIMER = $Timer


var ENEMY = null
var NAV = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ENEMY = load(enemy_path)
	NAV = get_node(nav_path)
	var instance = ENEMY.instance()
	
	instance.translation = self.global_transform.origin
	
	ENEMY_GROUP.add_child(instance)
	
	SPAWN_TIMER.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
