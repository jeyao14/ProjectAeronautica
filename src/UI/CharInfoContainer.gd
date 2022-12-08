extends VBoxContainer

onready var HP = $HBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/HP
onready var ATT = $HBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/ATT
onready var DEX = $HBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/DEX
onready var DEF = $HBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/DEF
onready var LUCK = $HBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/LUCK

onready var WEP_ICON = $HBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/WFrameCont/WeaponFrame/WIconCont/WeaponIcon
onready var ABI_ICON = $HBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/AFrameCont/AbilityFrame/AIconCont/AbilityIcon

onready var CHAR_SPRITE = $HBoxContainer/CenterContainer/CharacterSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func populate_info(character):
	CHAR_SPRITE.texture = character.SPRITE;
	
	HP.populate_values("HP", character.hp)
	ATT.populate_values("ATT", character.att)
	DEX.populate_values("DEX", character.dex)
	DEF.populate_values("DEF", character.def)
	LUCK.populate_values("LUCK", character.crit)
	
	WEP_ICON.texture = character.WEAPONICON
