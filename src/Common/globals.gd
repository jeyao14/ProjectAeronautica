extends Node

var CHARACTER_HANDLER = null # declared by character handler in ready function
var ROOT = null
var MENUS = null # declared by Main scene in ready function

var paused = false setget set_pause

onready var STATUS_EFFECT_HANDLER = preload("res://Common/StatusEffects/StatusEffectHandler.tscn")

# MENU ELEMENTS ----------------------------------
var MAIN_MENU = "res://UI/TestMainMenu.tscn"
var PAUSE_MENU = "res://UI/PauseMenu.tscn"

# UI ELEMENTS ------------------------------------
var GUI = "res://UI/GUI.tscn"
var GAME_OVER = "res://UI/EndGameScreen.tscn"
var DAMAGE_FLOATING_TEXT = "res://UI/DamageFloatingText.tscn"

# LEVEL ELEMENTS _________________________________
var TEST_LEVEL = "res://World/TestLevel.tscn"

# ROOM ELEMENTS ----------------------------------
	# TEST ROOMS
var TEST_ROOMS = [
	"res://World/TestRooms/SmallRoom.tscn",
	"res://World/TestRooms/MediumRoom.tscn"
]
var TEST_HALLWAYS = [
	"res://World/TestRooms/TestHallway.tscn",
	"res://World/TestRooms/TestLeftCornerHallway.tscn"
]

var TEST_ROOM_1 = "res://World/TestRooms/SmallRoom.tscn"

# CHARACTER ELEMENTS -----------------------------
export var HANDLER = "res://Characters/Shared/CharacterHandler.tscn"
export var MARIA = "res://Characters/TestCharacter/TestCharacter.tscn"
export var RHODES = "res://Characters/TestCharacter2/TestCharacter2.tscn"
export var OLIVE = "res://Characters/TestCharacter3/TestCharacter3.tscn"

func ready():
	ROOT = get_tree().root


func load_level(level):
	var instance = null
	# Add new level types here
	match(level):
		"TEST_LEVEL":
#			instance = load(TEST_LEVEL).instance()
			instance = load("res://World/TestRooms/TestLevel.tscn").instance()
		"TEST_ROOM_1":
			instance = load(TEST_ROOM_1).instance()
		_:
			return null
	if instance == null:
		return null
	ROOT.add_child(instance)
	return instance

func set_pause(value):
	paused = value
	get_tree().paused = value
