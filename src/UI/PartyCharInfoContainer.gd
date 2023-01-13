extends VBoxContainer

onready var HP = $VBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/HP
onready var ATT = $VBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/ATT
onready var DEX = $VBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/DEX
onready var DEF = $VBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/DEF
onready var LUCK = $VBoxContainer/VBoxContainer/MarginContainer/CenterContainer2/VBoxContainer/LUCK

onready var WEP_ICON = $VBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/WFrameCont/WeaponFrame/WIconCont/WeaponIcon
onready var ABI_ICON = $VBoxContainer/VBoxContainer/MarginContainer2/HBoxContainer/AFrameCont/AbilityFrame/AIconCont/AbilityIcon
onready var CHAR_NAME = $VBoxContainer/CenterContainer/Panel/Name
onready var CHAR_SPRITE = $VBoxContainer/CenterContainer/Control/CenterContainer/CharSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func populate_info(character):
	print(character)
	CHAR_NAME.text = character["CharacterName"]
	CHAR_SPRITE.animation = character["IdleAnim"]
	
	HP.populate_values("HP", character["HP"])
	ATT.populate_values("ATT", character["ATT"])
	DEX.populate_values("DEX", character["DEX"])
	DEF.populate_values("DEF", character["DEF"])
	LUCK.populate_values("LUCK", character["CRIT"])
	
	if(character["WeaponIcon"] != null):
		WEP_ICON.texture = load(character["WeaponIcon"])
