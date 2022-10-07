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
var benchCharacter1: Player
var benchCharacter2: Player
var character1: Player
var character2: Player
var character3: Player

func set_players(char1: Player, char2: Player, char3: Player):
	self.character1 = char1
	self.character2 = char2
	self.character3 = char3
	
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
		
	set_new_hp()
	
	character1.connect("player_health_changed", self, "set_new_hp")
	character2.connect("player_health_changed", self, "set_new_hp")
	character3.connect("player_health_changed", self, "set_new_hp")

func set_new_hp():
	A_HEALTHBAR.value = activeCharacter.hp
	B1_HEALTHBAR.value = benchCharacter1.hp
	B2_HEALTHBAR.value = benchCharacter2.hp

func set_current_ammo(new_ammo: int):
	pass

func set_max_ammo(max_ammo: int):
	pass

