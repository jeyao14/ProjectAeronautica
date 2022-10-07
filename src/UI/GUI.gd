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
	setActive()
		
	set_new_hp()
	
#	connecting signal for hp updating
	character1.connect("player_stat_changed", self, "set_new_hp")
	character2.connect("player_stat_changed", self, "set_new_hp")
	character3.connect("player_stat_changed", self, "set_new_hp")
	
	character1.connect("player_stat_changed", self, "set_new_hp")
	character2.connect("player_stat_changed", self, "set_new_hp")
	character3.connect("player_stat_changed", self, "set_new_hp")

func set_new_hp():
	A_HEALTHBAR.value = activeCharacter.hp
	B1_HEALTHBAR.value = benchCharacter1.hp
	B2_HEALTHBAR.value = benchCharacter2.hp
	
	A_CURRENTAMMO.text = activeCharacter.ammocount as String
	B1_CURRENTAMMO.text = benchCharacter1.ammocount as String
	B2_CURRENTAMMO.text = benchCharacter2.ammocount as String 
	
	A_MAXAMMO.text = activeCharacter.magsize as String
	B1_MAXAMMO.text = benchCharacter1.magsize as String
	B2_MAXAMMO.text = benchCharacter2.magsize as String 

func setActive():
	if(character1.active == true):
		activeCharacter = character1;
		benchCharacter1 = character2;
		benchCharacter2 = character3;
	if(character2.active == true):
		activeCharacter = character2;
		benchCharacter1 = character1;
		benchCharacter2 = character3;
	if(character3.active == true):
		activeCharacter = character3;
		benchCharacter1 = character1;
		benchCharacter2 = character2;

func set_current_ammo(new_ammo: int):
	pass

	

