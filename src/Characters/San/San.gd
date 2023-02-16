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

onready var ABILITYMARKER = $AbilityMarkerSpawn/Spatial
onready var ABILITYRAYCAST = $AbilityMarkerSpawn/Spatial/MeshInstance/RayCast

onready var TWEEN = get_node("Tween")

var is_reloading = false;
var reload_time
var ability_input = false

var target

func _ready():
#	don't let this stat go beyond 100
	getCharData()
	getPatternParameters()
	reload_time = 0.6/dex
	current_hp = hp;
	pass # Replace with function body.

func _physics_process(delta):
	
	set_animation()
	set_facing()
	GetSpawnerAmmoInfo()
	if(ABILITYMARKER.visible && ability_active):
		ability_rotate()
	if current_hp <= 0:
		set_alive()
	
	if SPAWNER.shoot:
		SPAWNER.mouse_direction = mouse_direction
#		print("Ammo: ", ammocount, "/", magsize)

func use_attack():
	if(!ability_active):
		SPAWNER.damage_min = weap_damage_min
		SPAWNER.damage_max = weap_damage_max
		SPAWNER.attack = att
		SPAWNER.shoot = true
	
func reload():
	pass

func stop_attack():
	SPAWNER.shoot = false

#func _on_HitBox_area_entered(area):

func use_ability():
	
	if facing_z == -1:
		ANIMATION.travel("Ability_f")
	if facing_z == 1:
		ANIMATION.travel("Ability_r")
	
func activate_ability():
	if(!ability_active):
		ABILITYMARKER.visible = true;
		ability_active = true
		stop_attack()
	
func stop_ability():
	if(!ability_active or !ABILITYMARKER.visible):
		return
	var t = 0.1
	ABILITYMARKER.visible = false
	GLOBALS.CHARACTER_HANDLER.control_toggle = false;
	TWEEN.interpolate_property(GLOBALS.CHARACTER_HANDLER, 
		"translation", 
		GLOBALS.CHARACTER_HANDLER.global_transform.origin, 
		GLOBALS.CHARACTER_HANDLER.translation + Vector3(target.x, 0, target.z),
		t,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	TWEEN.start()
	yield(get_tree().create_timer(t,false),"timeout");
	GLOBALS.CHARACTER_HANDLER.control_toggle = true;
	ABILITYTIMER.start()
	
#	if(ABILITYMARKERSPAWN.get_children()):
#		var a = ABILITYMARKERSPAWN.get_child(0)
#		ABILITYMARKERSPAWN.remove_child(a)
#		a.queue_free()
	
func ability_rotate():
	var a_range = 7
	var global_pos = GLOBALS.CHARACTER_HANDLER.global_transform.origin
	var direction_vector = -(global_pos - mouse_direction).normalized()
	var direction_angle = rad2deg(atan2(direction_vector.x, direction_vector.z))
	
	
	
	var scale_size = global_pos.distance_to(mouse_direction)
	
	ABILITYMARKER.rotate_mesh(direction_angle)
	if(scale_size < a_range):
		target = direction_vector * scale_size
		ABILITYMARKER.resize_mesh(scale_size*2)
	else:
		target = direction_vector * a_range
		ABILITYMARKER.resize_mesh(a_range*2)

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
	SPAWNER.cooldown = 0.5/dex
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
