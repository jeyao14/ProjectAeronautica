extends Player

onready var SPAWNER = $Spawner
onready var ABILITYTIMER = $AbilityCooldown
onready var	TURRETGROUP = $TurretGroup
onready var TURRETTYPE = preload("res://Characters/TestCharacter/Turret/TemplateTurret.tscn")
var ammocount = magsize
var ability_active = false

func _ready():
#	don't let this stat go beyond 100
	getPatternParameters()
	print("Ammo: ", ammocount, "/", magsize)
	pass # Replace with function body.

func _physics_process(delta):
	
	set_animation()
	set_facing()
	GetSpawnerAmmoInfo()
	if SPAWNER.shoot:
		SPAWNER.mouse_direction = mouse_direction
#		print("Ammo: ", ammocount, "/", magsize)

func use_attack():
	SPAWNER.shoot = true
	

func reload():
	ammocount = magsize;
	SPAWNER.ammocount = ammocount;
#	print("Ammo: ", ammocount, "/", magsize)

func stop_attack():
	SPAWNER.shoot = false

func _on_HitBox_area_entered(area):
	print("AREA ENTERED 1")
	hurt_player()
	pass # Replace with function body.

func use_ability():
	print("using test character 1 ability")
	if(TURRETGROUP.get_child_count() == 0 and not ability_active):
		ability_active = true
		var instance = TURRETTYPE.instance()
		var global_pos = self.global_transform.origin
		var spawn_origin = Vector3(mouse_direction.x, global_pos.y, mouse_direction.z)
		instance.translation = spawn_origin;
		instance.connect("turret_death",self,"ability_cooldown")
		TURRETGROUP.add_child(instance);

func ability_cooldown():
	ABILITYTIMER.start()
	print("ability_cooldown")

func _on_HitBox_body_entered(body):
	print("BODY ENTERED 1")
	hurt_player()
	pass # Replace with function body.
	
func GetSpawnerAmmoInfo():
	ammocount = SPAWNER.ammocount
	
func getPatternParameters():
	SPAWNER.bullet_path = "res://Characters/TestCharacter/TestProjectile.tscn"
	print("bullet path: ", SPAWNER.bullet_path)
	SPAWNER.cooldown = 0.3/dex
	SPAWNER.ammocount = magsize;
	ammocount = magsize;
	SPAWNER.full_auto = false;
	SPAWNER.burst_count = 0;
	SPAWNER.spread_count = 0;
	SPAWNER.spread_angle = 0;
	SPAWNER.random = false;
	SPAWNER.bullet_speed_override = 75;

func test_signal_receive():
	print("SIGNAL")


func _on_AbilityCooldown_timeout():
	ability_active = false
	pass # Replace with function body.
