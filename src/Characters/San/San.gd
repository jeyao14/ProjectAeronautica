extends Player
class_name San

onready var data = ImportData.char_data["san"]
onready var character_icon : String = data["CharacterIcon"]
#onready var weapon_icon : String = data["WeaponIcon"]
onready var SPAWNER = $Spawner
onready var ABILITYTIMER = $AbilityCooldown

onready var CHARACTERICON = load(character_icon)
onready var WEAPONICON = preload("res://Assets/Characters/Maria/rifle.png")
onready var charactername = "San"

var is_reloading = false;
var reload_time

var ability_active = false

func _ready():
#	don't let this stat go beyond 100
	getCharData()
	getPatternParameters()
	print("san magsize: ", magsize)
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
	yield(get_tree().create_timer(reload_time,false),"timeout");
	ammocount = magsize;
	SPAWNER.ammocount = ammocount;
	is_reloading = false;
#	print("Ammo: ", ammocount, "/", magsize)

func stop_attack():
	SPAWNER.shoot = false

#func _on_HitBox_area_entered(area):

func use_ability():
	
	if facing_z == -1:
		ANIMATION.travel("Ability_f")
	if facing_z == 1:
		ANIMATION.travel("Ability_r")
	
func activate_ability():
	pass
	
func ability_cooldown():
	ABILITYTIMER.start()

func _on_HitBox_body_entered(body):
	
#	hurt_player()
	pass # Replace with function body.
	
func GetSpawnerAmmoInfo():
	ammocount = SPAWNER.ammocount
	emit_signal("ammo_changed")
	
func getCharData():
	hp = data["HP"]
	att = data["ATT"]
	def = data["DEF"]
	dex = data["DEX"]
	crit = data["CRIT"]
	magsize = data["Magsize"]
	weap_damage_min = data["DamageMin"]
	weap_damage_max = data["DamageMax"]
	
	idle_anim = "Maria_idle"
	
func getPatternParameters():
	SPAWNER.cooldown = 0.25/dex
	SPAWNER.ammocount = magsize;
	ammocount = magsize;
#	SPAWNER.full_auto = false;
#	SPAWNER.burst_count = 0;
#	SPAWNER.spread_count = 0;
#	SPAWNER.spread_angle = 0;
#	SPAWNER.random = false;
#	SPAWNER.bullet_speed_override = 75;

func test_signal_receive():
	pass

func _on_AbilityCooldown_timeout():
	ability_active = false
	pass # Replace with function body.
	
func spawn_damage_num(value):
	var text = damagetext.instance()
	add_child(text)
	text.set_values(value, Vector3(self.global_transform.origin.x, self.global_transform.origin.y+2, self.global_transform.origin.z))
