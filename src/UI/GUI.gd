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

var ACTIVE_CHARACTER: Player
var BENCH_CHARACTER_1: Player
var BENCH_CHARACTER_2: Player
var CHARACTER_1: Player
var CHARACTER_2: Player
var CHARACTER_3: Player

func set_players(char1: Player, char2: Player, char3: Player):
	self.CHARACTER_1 = char1
	self.CHARACTER_2 = char2
	self.CHARACTER_3 = char3
	
	if(CHARACTER_1.active == true):
		ACTIVE_CHARACTER = CHARACTER_1;
		BENCH_CHARACTER_1 = CHARACTER_2;
		BENCH_CHARACTER_2 = CHARACTER_3;
	if(CHARACTER_2.active == true):
		ACTIVE_CHARACTER = CHARACTER_2;
		BENCH_CHARACTER_1 = CHARACTER_1;
		BENCH_CHARACTER_2 = CHARACTER_3;
	if(CHARACTER_3.active == true):
		ACTIVE_CHARACTER = CHARACTER_3;
		BENCH_CHARACTER_1 = CHARACTER_1;
		BENCH_CHARACTER_2 = CHARACTER_2;
		
	set_new_hp()
	
	CHARACTER_1.connect("player_health_changed", self, "set_new_hp")
	CHARACTER_2.connect("player_health_changed", self, "set_new_hp")
	CHARACTER_3.connect("player_health_changed", self, "set_new_hp")

func set_new_hp():
	A_HEALTHBAR.value = ACTIVE_CHARACTER.hp
	B1_HEALTHBAR.value = BENCH_CHARACTER_1.hp
	B2_HEALTHBAR.value = BENCH_CHARACTER_2.hp

func set_current_ammo(new_ammo: int):
	pass

func set_max_ammo(max_ammo: int):
	pass

