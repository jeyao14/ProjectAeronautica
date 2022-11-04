extends Player

onready var SPAWNER = $Spawner
onready var SHOOTTIMER = $ShootTimer

onready var CHARACTERICON = preload("res://Assets/Characters/Olive_icon.png")
onready var WEAPONICON = preload("res://Assets/UI/Icons/WeaponIcons/smg.png")
onready var charactername = "Olive"

var is_reloading = false;
var reload_time

func _ready():
	getPatternParameters()
	reload_time = 0.6/dex
	current_hp = hp;
	pass # Replace with function body.

func _physics_process(delta):
	set_animation()
	set_facing()
	GetSpawnerAmmoInfo()
	if current_hp <= 0:
		set_alive()
	if SPAWNER.shoot:
		SPAWNER.mouse_direction = mouse_direction
#		print("Ammo: ", ammocount, "/", magsize)

func use_attack():
	if(ammocount > 0 && !is_reloading):
		SPAWNER.damage_min = weap_damage_min
		SPAWNER.damage_max = weap_damage_max
		SPAWNER.attack = att
		SPAWNER.shoot = true
	

func reload():
	if(is_reloading || ammocount == magsize):
		return
	is_reloading = true;
	SPAWNER.shoot = false;
	emit_signal("start_reload")
	print("Maria reload time: ", reload_time)
	yield(get_tree().create_timer(reload_time,false),"timeout");
	ammocount = magsize;
	SPAWNER.ammocount = ammocount;
	is_reloading = false;
#	print("Ammo: ", ammocount, "/

func stop_attack():
	SPAWNER.shoot = false

func _on_HitBox_area_entered(area):
	print("AREA ENTERED 3")
#	hurt_player()
	pass # Replace with function body.

func use_ability():
	SPAWNER.applied_status = "slow"
	yield(get_tree().create_timer(10,false),"timeout");
	SPAWNER.applied_status = ""
	
func _on_HitBox_body_entered(body):
	print("BODY ENTERED 3")
#	hurt_player()
	pass # Replace with function body.
	
func GetSpawnerAmmoInfo():
	ammocount = SPAWNER.ammocount
	
func getPatternParameters():
#	SPAWNER.cooldown = 0.9 + -((dex*0.8)/100.0)
	SPAWNER.bullet_path = "res://Characters/TestCharacter3/OliveProjectile.tscn"
	SPAWNER.cooldown = 0.25/dex
	SPAWNER.ammocount = magsize;
	ammocount = magsize;

func test_signal_receive():
	print("SIGNAL")

func set_alive():
	if(alive == true):
		alive = false;
		if(GLOBALS.CHARACTER_HANDLER):
			print("death detected")
			GLOBALS.CHARACTER_HANDLER.find_next_alive_char()
