extends Spatial


export var enemy_path = "res://Enemies/TestEnemy/TestEnemy.tscn"
export var nav_path = "../Navigation"
export var max_enemy_count = 10
export var enemy_spawn_cap = 5
export var enemies_per_spawn = 1
export var spawn_radius = 10

onready var ENEMY_GROUP = $EnemyGroup
onready var SPAWN_TIMER = $SpawnTimer


var ENEMY = null
var NAV = null
var spawning = false

# Called when the node enters the scene tree for the first time.
func _ready():
	NAV = get_node(nav_path)
	ENEMY = load(enemy_path)
	
	pass # Replace with function body.

func _physics_process(delta):
	var enemy_count = ENEMY_GROUP.get_children().size()
	if not spawning and (enemy_count < enemy_spawn_cap or enemy_spawn_cap == -1) and (max_enemy_count > 0 or max_enemy_count == -1):
		activate_spawner()
	pass

func activate_spawner():
	spawning = true
	for i in enemies_per_spawn:
		spawn_enemy()
	if max_enemy_count > 0:
		max_enemy_count -= 1
	SPAWN_TIMER.start()

func spawn_enemy():
	var spawn_modifier = Vector3.ZERO
	if spawn_radius > 0:
		randomize()
		var rand_x = rand_range(-spawn_radius, spawn_radius)
		randomize()
		var rand_z = rand_range(-spawn_radius, spawn_radius)
		spawn_modifier = Vector3(rand_x, 0, rand_z)
	var instance = ENEMY.instance()
	instance.NAV = NAV
	instance.translation = self.global_transform.origin + spawn_modifier
	
	ENEMY_GROUP.add_child(instance)

func _on_SpawnTimer_timeout():
	spawning = false
	pass # Replace with function body.
