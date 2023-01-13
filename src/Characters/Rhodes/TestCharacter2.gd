extends Player

onready var data = ImportData.char_data["rhodes"]
onready var character_icon : String = data["CharacterIcon"]
onready var weapon_icon : String = data["WeaponIcon"]
onready var SPAWNER = $Spawner
onready var ASPAWNER = $AbilitySpawner
onready var SHOOTTIMER = $ShootTimer
#	$Projectile.connect("test_signal", self, "test_signal_receive")

onready var CHARACTERICON = load(character_icon)
onready var WEAPONICON = load(weapon_icon)
onready var charactername = "Rhodes"

export var ability_damage_max = 10
export var ability_damage_min = 20

var is_reloading = false;
var reload_time

func _ready():
#	don't let this stat go beyond 100'
	getCharData()
	getPatternParameters()
	getAbilityParameters()
	reload_time = 0.6/dex
	current_hp = hp;

func _physics_process(delta):
	set_animation()
	set_facing()
	GetSpawnerAmmoInfo()
	if current_hp <= 0:
		set_alive()
	if SPAWNER.shoot:
		SPAWNER.mouse_direction = mouse_direction
#		print("Ammo: ", ammocount, "/", magsize)
	if ASPAWNER.shoot:
		ASPAWNER.mouse_direction = mouse_direction
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
	yield(get_tree().create_timer(reload_time,false),"timeout");
	ammocount = magsize;
	SPAWNER.ammocount = ammocount;
	is_reloading = false;
#	print("Ammo: ", ammocount, "/
#	print("Ammo: ", ammocount, "/", magsize)

func stop_attack():
	SPAWNER.shoot = false

func _on_HitBox_area_entered(area):
#	hurt_player()
	pass # Replace with function body.

func use_ability():
	ASPAWNER.damage_min = ability_damage_min
	ASPAWNER.damage_max = ability_damage_max
	ASPAWNER.attack = att
	ASPAWNER.shoot = true;
	
func stop_ability():
	ASPAWNER.shoot = false;

func _on_HitBox_body_entered(body):
#	hurt_player()
	pass # Replace with function body.
	
func GetSpawnerAmmoInfo():
	ammocount = SPAWNER.ammocount
	
func getCharData():
	hp = data["HP"]
	att = data["ATT"]
	def = data["DEF"]
	dex = data["DEX"]
	crit = data["CRIT"]
	magsize = data["Magsize"]
	weap_damage_min = data["DamageMin"]
	weap_damage_max = data["DamageMax"]
	
	idle_anim = "Calli_idle"
	
func getPatternParameters():
#	SPAWNER.cooldown = 0.9 + -((dex*0.8)/100.0)
	SPAWNER.bullet_path = "res://Characters/Rhodes/RhodesProjectile.tscn"
	SPAWNER.cooldown = 0.25/dex
	SPAWNER.ammocount = magsize;
	ammocount = magsize;

func getAbilityParameters():
	ASPAWNER.bullet_path = "res://Characters/Rhodes/RhodesAbilityProjectile.tscn"
	ASPAWNER.applied_status = "stun"
#	ASPAWNER.cooldown = 2.0

func test_signal_receive():
	pass
	
#func set_alive():
#	if(alive == true):
#		alive = false;
#		if(GLOBALS.CHARACTER_HANDLER):
#			GLOBALS.CHARACTER_HANDLER.find_next_alive_char()
			
func spawn_damage_num(value):
	var text = damagetext.instance()
	add_child(text)
	text.set_values(value, Vector3(self.global_transform.origin.x, self.global_transform.origin.y+2, self.global_transform.origin.z))


