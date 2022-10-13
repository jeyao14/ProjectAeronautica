extends Player

onready var SPAWNER = $Spawner
onready var ASPAWNER = $AbilitySpawner
onready var SHOOTTIMER = $ShootTimer
#	$Projectile.connect("test_signal", self, "test_signal_receive")

func _ready():
#	don't let this stat go beyond 100
	getPatternParameters()
	getAbilityParameters()
	print("Char2 Ammo: ", ammocount, "/", magsize)

func _physics_process(delta):
	set_animation()
	set_facing()
	GetSpawnerAmmoInfo()
	if SPAWNER.shoot:
		SPAWNER.mouse_direction = mouse_direction
#		print("Ammo: ", ammocount, "/", magsize)
	if ASPAWNER.shoot:
		ASPAWNER.mouse_direction = mouse_direction
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
	print("AREA ENTERED 2")
	hurt_player()
	pass # Replace with function body.

func use_ability():
	print("using character 2 ability")
	ASPAWNER.shoot = true;
	
func stop_ability():
	ASPAWNER.shoot = false;

func _on_HitBox_body_entered(body):
	print("BODY ENTERED 2")
	hurt_player()
	pass # Replace with function body.
	
func GetSpawnerAmmoInfo():
	ammocount = SPAWNER.ammocount
	
func getPatternParameters():
#	SPAWNER.cooldown = 0.9 + -((dex*0.8)/100.0)
	SPAWNER.bullet_path = "res://Characters/TestCharacter2/RhodesProjectile.tscn"
	print("bullet path: ", SPAWNER.bullet_path)
	SPAWNER.cooldown = 0.3/dex
	SPAWNER.ammocount = magsize;
	ammocount = magsize;
	SPAWNER.full_auto = false;
	SPAWNER.burst_count = 0;
	SPAWNER.spread_count = 5;
	SPAWNER.spread_angle = 25;
	SPAWNER.random = true;
	SPAWNER.bullet_speed_override_range.x = 40;
	SPAWNER.bullet_speed_override_range.y = 60;

func getAbilityParameters():
	ASPAWNER.bullet_path = "res://Characters/TestCharacter2/RhodesAbilityProjectile.tscn"
	ASPAWNER.cooldown = 2
	ASPAWNER.uses_ammo = false;
	ASPAWNER.ammocount = -1;
	ASPAWNER.full_auto = false;
	ASPAWNER.burst_count = 0;
	ASPAWNER.spread_count = 0;
	ASPAWNER.spread_angle = 0;
	ASPAWNER.random = false;
	ASPAWNER.bullet_speed_override = 40;

func test_signal_receive():
	print("SIGNAL")
