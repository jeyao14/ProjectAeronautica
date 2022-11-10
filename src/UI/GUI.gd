extends Control

onready var P1_CHARACTERICON = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer/Party1/HealthPanel/Icon/CharacterIcon
onready var P1_HEALTHBAR = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer/Party1/HealthPanel/Health/VBoxContainer/HealthBar
onready var P1_CURRENTHEALTH = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer/Party1/HealthPanel/Health/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/HealthNum/CurrentHealth
onready var P1_MAXHEALTH = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer/Party1/HealthPanel/Health/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/HealthNum/MaxHealth

onready var P2_CHARACTERICON = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer2/Party2/HealthPanel/Icon/CharacterIcon
onready var P2_HEALTHBAR = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer2/Party2/HealthPanel/Health/VBoxContainer/HealthBar
onready var P2_CURRENTHEALTH = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer2/Party2/HealthPanel/Health/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/HealthNum/CurrentHealth
onready var P2_MAXHEALTH = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer2/Party2/HealthPanel/Health/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/HealthNum/MaxHealth

onready var P3_CHARACTERICON = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer3/Party3/HealthPanel/Icon/CharacterIcon
onready var P3_HEALTHBAR = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer3/Party3/HealthPanel/Health/VBoxContainer/HealthBar
onready var P3_CURRENTHEALTH = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer3/Party3/HealthPanel/Health/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/HealthNum/CurrentHealth
onready var P3_MAXHEALTH = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer3/Party3/HealthPanel/Health/VBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/HealthNum/MaxHealth

onready var P1_HEALTHTWEEN = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer/Party1/HealthPanel/Health/VBoxContainer/HealthTween
onready var P2_HEALTHTWEEN = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer2/Party2/HealthPanel/Health/VBoxContainer/HealthTween
onready var P3_HEALTHTWEEN = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer3/Party3/HealthPanel/Health/VBoxContainer/HealthTween

onready var WEAPONICON = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/AmmoPanel/HBoxContainer/AmmoPanel/WeaponFrame/WeaponFrameHead/WIconCont/WeaponIcon
onready var CURRENTAMMO = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/AmmoPanel/HBoxContainer/AmmoPanel/AmmoCountCont/AmmoCount/HBoxContainer/HBoxContainer/CurrentAmmo
onready var MAXAMMO = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/AmmoPanel/HBoxContainer/AmmoPanel/AmmoCountCont/AmmoCount/HBoxContainer/HBoxContainer/MaxAmmo

onready var RELOADBAR = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/AmmoPanel/HBoxContainer/AmmoPanel/WeaponFrame/ReloadPanel/ReloadBar
onready var RELOADTWEEN = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/AmmoPanel/HBoxContainer/AmmoPanel/WeaponFrame/ReloadPanel/ReloadTween

onready var P1_CONTAINER = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer/Party1
onready var P2_CONTAINER = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer2/Party2
onready var P3_CONTAINER = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer3/Party3
onready var PANEL1TWEEN = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer/Panel1Tween
onready var PANEL2TWEEN = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer2/Panel2Tween
onready var PANEL3TWEEN = $MarginContainer/Rows/Bot/MarginContainer/PanelContainer/PartyRows/HBoxContainer3/Panel3Tween

var ACTIVE_CHARACTER: Player
var CHARACTER_1: Player
var CHARACTER_2: Player
var CHARACTER_3: Player

var original_color = Color("#ac2020")
var new_color = Color("#ffc4c4")
var active_color = Color("#ffffff")
var inactive_color = Color("#82ffffff")


func setup_signals():
	var handler = GLOBALS.CHARACTER_HANDLER
	handler.connect("gui_set_players", self, "set_players")
	handler.connect("gui_set_active", self, "setActive")
	

func set_players(char1: Player, char2: Player, char3: Player):
#func set_players():
#	if not GLOBALS.CHARACTER_HANDLER:
#		return
#	var handler = GLOBALS.CHARACTER_HANDLER
#	var char1 = handler.CHARACTER_1
#	var char2 = handler.CHARACTER_2
#	var char3 = handler.CHARACTER_3
	
	self.CHARACTER_1 = char1
	self.CHARACTER_2 = char2
	self.CHARACTER_3 = char3
	#when loading game for first time, set default character order
	setActive()
	initialize_values()
	
#	connecting signal for hp updating
	CHARACTER_1.connect("player_stat_changed", self, "set_new_values")
	CHARACTER_2.connect("player_stat_changed", self, "set_new_values")
	CHARACTER_3.connect("player_stat_changed", self, "set_new_values")
	
	CHARACTER_1.connect("ammo_changed", self, "change_ammo")
	CHARACTER_2.connect("ammo_changed", self, "change_ammo")
	CHARACTER_3.connect("ammo_changed", self, "change_ammo")
	
	CHARACTER_1.connect("player_damaged", self, "change_P1_hp")
	CHARACTER_2.connect("player_damaged", self, "change_P2_hp")
	CHARACTER_3.connect("player_damaged", self, "change_P3_hp")
	
	CHARACTER_1.connect("start_reload", self, "start_reload_anim")
	CHARACTER_2.connect("start_reload", self, "start_reload_anim")
	CHARACTER_3.connect("start_reload", self, "start_reload_anim")

func initialize_values():
	P1_HEALTHBAR.max_value = CHARACTER_1.hp
	P2_HEALTHBAR.max_value = CHARACTER_2.hp
	P3_HEALTHBAR.max_value = CHARACTER_3.hp
	
	P1_HEALTHBAR.value = CHARACTER_1.current_hp
	P2_HEALTHBAR.value = CHARACTER_2.current_hp
	P3_HEALTHBAR.value = CHARACTER_3.current_hp
	
	P1_CURRENTHEALTH.text = CHARACTER_1.current_hp as String
	P2_CURRENTHEALTH.text = CHARACTER_2.current_hp as String
	P3_CURRENTHEALTH.text = CHARACTER_3.current_hp as String
	
	P1_MAXHEALTH.text = CHARACTER_1.hp as String
	P2_MAXHEALTH.text = CHARACTER_2.hp as String
	P3_MAXHEALTH.text = CHARACTER_3.hp as String
	
	P1_CHARACTERICON.set_texture(CHARACTER_1.CHARACTERICON)
	P2_CHARACTERICON.set_texture(CHARACTER_2.CHARACTERICON)
	P3_CHARACTERICON.set_texture(CHARACTER_3.CHARACTERICON)
	
	WEAPONICON.set_texture(ACTIVE_CHARACTER.WEAPONICON)
	
	CURRENTAMMO.text = ACTIVE_CHARACTER.ammocount as String
	MAXAMMO.text = ACTIVE_CHARACTER.magsize as String

	RELOADBAR.value = 100

func set_new_values():
	WEAPONICON.set_texture(ACTIVE_CHARACTER.WEAPONICON)
	
	RELOADTWEEN.stop_all()
	RELOADBAR.value = 100
	
func setActive():
#	var temp = PARTY_1
	if(CHARACTER_1.active): #if new active character is located in bench1, swap active and bench1
		ACTIVE_CHARACTER = CHARACTER_1
		PANEL1TWEEN.interpolate_property(P1_CONTAINER, "modulate", P1_CONTAINER.modulate, active_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		PANEL2TWEEN.interpolate_property(P2_CONTAINER, "modulate", P2_CONTAINER.modulate, inactive_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		PANEL3TWEEN.interpolate_property(P3_CONTAINER, "modulate", P3_CONTAINER.modulate, inactive_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif(CHARACTER_2.active): #if new active character is located in bench2, swap active and bench2
		ACTIVE_CHARACTER = CHARACTER_2
		PANEL1TWEEN.interpolate_property(P1_CONTAINER, "modulate", P1_CONTAINER.modulate, inactive_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		PANEL2TWEEN.interpolate_property(P2_CONTAINER, "modulate", P2_CONTAINER.modulate, active_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		PANEL3TWEEN.interpolate_property(P3_CONTAINER, "modulate", P3_CONTAINER.modulate, inactive_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	elif(CHARACTER_3.active): #if new active character is located in bench2, swap active and bench2
		ACTIVE_CHARACTER = CHARACTER_3
		PANEL1TWEEN.interpolate_property(P1_CONTAINER, "modulate", P1_CONTAINER.modulate, inactive_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		PANEL2TWEEN.interpolate_property(P2_CONTAINER, "modulate", P2_CONTAINER.modulate, inactive_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		PANEL3TWEEN.interpolate_property(P3_CONTAINER, "modulate", P3_CONTAINER.modulate, active_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	PANEL1TWEEN.start()
	PANEL2TWEEN.start()
	PANEL3TWEEN.start()
	set_new_values() #update GUI

func start_reload_anim():
	print("start_reload_anim")
	RELOADBAR.value = 0
	RELOADTWEEN.interpolate_property(RELOADBAR, "value", RELOADBAR.value, 100, ACTIVE_CHARACTER.reload_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	RELOADTWEEN.start()

func change_ammo():
	CURRENTAMMO.text = ACTIVE_CHARACTER.ammocount as String
	MAXAMMO.text = ACTIVE_CHARACTER.magsize as String

func change_P1_hp():
	print("change_P1_hp")
	var P1_bar_style = P1_HEALTHBAR.get("custom_styles/fg")
	
	P1_HEALTHTWEEN.interpolate_property(P1_HEALTHBAR, "value", P1_HEALTHBAR.value, CHARACTER_1.current_hp, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	P1_CURRENTHEALTH.text = CHARACTER_1.current_hp as String
	P1_HEALTHTWEEN.interpolate_property(P1_bar_style, "bg_color", original_color, new_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	P1_HEALTHTWEEN.interpolate_property(P1_bar_style, "bg_color", new_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	P1_HEALTHTWEEN.start()

func change_P2_hp():
	print("change_P2_hp")
	var P2_bar_style = P2_HEALTHBAR.get("custom_styles/fg")
	
	P2_HEALTHTWEEN.interpolate_property(P2_HEALTHBAR, "value", P2_HEALTHBAR.value, CHARACTER_2.current_hp, 0.2, Tween.TRANS_LINEAR)
	P2_CURRENTHEALTH.text = CHARACTER_2.current_hp as String
	P2_HEALTHTWEEN.interpolate_property(P2_bar_style, "bg_color", original_color, new_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	P2_HEALTHTWEEN.interpolate_property(P2_bar_style, "bg_color", new_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	P2_HEALTHTWEEN.start()

func change_P3_hp():
	print("change_P3_hp")
	var P3_bar_style = P3_HEALTHBAR.get("custom_styles/fg")
	
	P3_HEALTHTWEEN.interpolate_property(P3_HEALTHBAR, "value", P3_HEALTHBAR.value, CHARACTER_3.current_hp, 0.2, Tween.TRANS_LINEAR)
	P3_CURRENTHEALTH.text = CHARACTER_3.current_hp as String
	P3_HEALTHTWEEN.interpolate_property(P3_bar_style, "bg_color", original_color, new_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	P3_HEALTHTWEEN.interpolate_property(P3_bar_style, "bg_color", new_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	P3_HEALTHTWEEN.start()
