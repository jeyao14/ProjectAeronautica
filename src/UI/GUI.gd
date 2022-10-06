extends CanvasLayer

onready var A_HEALTHBAR = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Active/CenterContainer/HealthBar
onready var A_CURRENTAMMO = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Active/HBoxContainer/CurrentAmmo
onready var A_MAXAMMO = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Active/HBoxContainer/MaxAmmo

onready var B1_HEALTHBAR = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Bench1/CenterContainer3/HealthBar
onready var B1_CURRENTAMMO = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Bench1/HBoxContainer3/CurrentAmmo
onready var B1_MAXAMMO = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Bench1/HBoxContainer3/MaxAmmo

onready var B2_HEALTHBAR = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Bench2/CenterContainer2/HealthBar
onready var B2_CURRENTAMMO = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Bench2/HBoxContainer2/CurrentAmmo
onready var B2_MAXAMMO = $MarginContainer/Rows/Bot/MarginContainer/PartyRows/Bench2/HBoxContainer2/MaxAmmo

var activeCharacter: Player
var inactiveChar1: Player
var inactiveChar2: Player

func set_players(active: Player, bench1: Player, bench2: Player):
	self.activeCharacter = active
	self.inactiveChar1 = bench1
	self.inactiveChar2 = bench2
	
	set_new_hp(activeCharacter.hp)
	set_current_ammo(activeCharacter.ammocount)
	set_max_ammo(activeCharacter.magsize)
	
	set_new_hp(inactiveChar1.hp)
	set_current_ammo(inactiveChar1.ammocount)
	set_max_ammo(inactiveChar1.magsize)
	
	set_new_hp(inactiveChar2.hp)
	set_current_ammo(inactiveChar2.ammocount)
	set_max_ammo(inactiveChar2.magsize)
	
	activeCharacter.connect("player_health_changed", self, "set_new_hp")

func set_new_hp(new_hp: int):
	A_HEALTHBAR.value = new_hp

func set_current_ammo(new_ammo: int):
	pass

func set_max_ammo(max_ammo: int):
	pass

